#!/usr/bin/ruby

require 'open-uri'
require 'optparse'

baseUrl,config,match = ""
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: wdetail habo monitor [options]"

  opts.on("--url testurl","input your username") do |v|
    baseUrl = v
  end

  opts.on("--config serverlist","input your password") do |v|
    config = v
  end

  opts.on("--match matchstr","input your appid") do |v|
    match = v
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

begin
  optparse.parse!
  if !baseUrl || !config || !match
    puts optparse
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end

def red(message)
  color = '31;1'
  "\e[#{color}m#{message}\e[0m"
end

file = File.open(config,"r").each_line do |line|

  host = line.strip
  if host !~ /\.pre\./
    othost =  baseUrl.gsub(/http:\/\/.*\//,"http://"+host+".ot.m.taobao.com/")
    html = '';
    begin
      open(othost) do |content|
        content.each_line {|str| html += str}
      end
    rescue

    end

    puts html.include?(match) ? host : red(host)

  end
  #p line.strip
end



