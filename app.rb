#!/usr/bin/env ruby
require 'gli'

URLBuilder = Struct.new(:bucket_name, :version, :expiration_minutes) do
  def presigned_get_url
    # http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/S3Object.html#url_for-instance_method
    options = {}
    options[:expires] = self.expiration_minutes.to_i * 60 if self.expiration_minutes
    object.url_for(:get, options)
  end

  protected

  def object
    fname = [ folder_name, file_name ].compact.join('/')
    bucket.objects[fname].tap do |obj|
      raise "File #{bucket_name}/#{fname} does not exist" unless obj.exists?
    end
  end

  def bucket
    s3.buckets[bucket_name].tap do |bucket|
      raise "Bucket #{bucket_name} does not exist" unless bucket.exists?
    end
  end

  def s3
    require 'aws-sdk-v1'
    @s3 ||= AWS::S3.new
  end
end

class ApplianceLXCURLBuilder < URLBuilder
  def initialize version, expiration_minutes
    super "conjur-dev-lxc-images", version, expiration_minutes
  end
  
  def folder_name
    nil
  end
  
  def file_name
    "conjur-appliance-#{version}.tar.bz2"
  end
end

class ApplianceDockerURLBuilder < URLBuilder
  def initialize version, expiration_minutes
    super "conjur-ci-images", version, expiration_minutes
  end
  
  def folder_name
    "docker"
  end
  
  def file_name
    "conjur-appliance-#{version}.tar"
  end
end

class DebURLBuilder < URLBuilder
  attr_reader :package
  
  def initialize package, version, expiration_minutes
    super "conjur-ci-images", version, expiration_minutes
    
    @package = package
  end
  
  def folder_name
    "debian"
  end
  
  def file_name
    "#{package}_#{version}_amd64.deb"
  end
end

class CLI
  extend GLI::App

  program_desc 'Get presigned URL links to Conjur artifacts'

  version "0.3.0"

  subcommand_option_handling :normal
  arguments :strict
  
  def self.standard_options c
    c.desc 'Version number'
    c.arg_name 'version'
    c.flag [:v, :"artifact-version"]
      
    c.desc 'Expiration time in minutes'
    c.arg_name 'expiration'
    c.flag [:e, :"expiration-minutes"]    
  end

  desc "Get a download link to the LXC appliance"
  command :"appliance-lxc" do |c|
    standard_options c
    c.action do |global_options,options,args|
      puts ApplianceLXCURLBuilder.new(options[:"artifact-version"], options[:"expiration-minutes"]).presigned_get_url
    end
  end
  
  desc "Get a download link to the Docker appliance"
  command :"appliance-docker" do |c|
    standard_options c
    c.action do |global_options,options,args|
      puts ApplianceDockerURLBuilder.new(options[:"artifact-version"], options[:"expiration-minutes"]).presigned_get_url
    end
  end
  
  desc "Get a download link to a Debian extension package"
  arg "package"
  command :"deb" do |c|
    standard_options c
    c.action do |global_options,options,args|
      package = args.shift
      raise "Missing argument : package" unless package
      
      puts DebURLBuilder.new(package, options[:"artifact-version"], options[:"expiration-minutes"]).presigned_get_url
    end
  end
end

exit CLI.run(ARGV)
