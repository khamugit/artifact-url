#!/usr/bin/env ruby

require 'optparse'

Downloader = Struct.new(:bucket_name, :version) do
  def presigned_url
    object.presigned_url(:get)
  end      
  
  protected
  
  def object
    fname = "conjur-appliance-#{version}.tar.bz2"
    bucket.object(fname)#.tap do |obj|
    #  raise "File #{bucket_name}/#{fname} does not exist" unless obj.exists?
    #end
  end
  
  def bucket
    s3.bucket(bucket_name)#.tap do |bucket|
    #  raise "Bucket #{bucket_name} does not exist" unless bucket.exists?
    #end
  end
  
  def region; 'us-east-1'; end
  
  def s3
    require 'aws-sdk'
    @s3 ||= Aws::S3::Resource.new(region: region)
  end          
end

require 'optparse'

options = {}
options[:"appliance-version"] = ENV['DEFAULT_VERSION']
OptionParser.new do |opts|
  opts.banner = "Usage: lxc-download-link [options]"

  opts.on("--appliance-version", "Appliance build version") do |v|
    options[:"appliance-version"] = v
  end
  
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

puts Downloader.new('conjur-dev-lxc-images', options[:"appliance-version"]).presigned_url
