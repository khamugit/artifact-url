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
    fname = "conjur-appliance-#{version}.tar.bz2"
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

class CLI
  extend GLI::App

  program_desc 'Get presigned URL links to LXC appliance artifacts'

  version "0.2.0"

  subcommand_option_handling :normal
  arguments :strict

  command :get do |c|
    c.desc 'Appliance version number'
    c.default_value ENV['DEFAULT_VERSION']
    c.arg_name 'version'
    c.flag [:v, :"appliance-version"]
      
    c.desc 'Expiration time in minutes'
    c.arg_name 'expiration'
    c.flag [:e, :"expiration-minutes"]
      
    c.action do |global_options,options,args|
      puts URLBuilder.new("conjur-dev-lxc-images", options[:"appliance-version"], options[:"expiration-minutes"]).presigned_get_url
    end
  end
end

exit CLI.run(ARGV)
