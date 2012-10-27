#!/usr/bin/ruby

#$: << ("#{File.dirname(__FILE__)}/nokogiri-1.5.6.rc2/lib") if __FILE__ == $0
#require "nokogiri.rb"

require "nokogiri"
require 'open-uri'

#doc = Nokogiri::HTML(open('http://a.m.tmall.com/i10032396923.htm?v=1'))
#doc.css('.promomtion-price').each do |price|
#  puts price.content
#end
if ARGV.length == 0
  puts "lack of appName";
  exit;
end

class PeSystem
  def self.getContent(td)
    _content = td.content;
    return  _content = _content.strip if !_content.nil?;
  end

  def self.putsOnline(hoststable)
    hoststable.css("tr").each do |tr|
      tds = tr.css("td");
      len = tds.length;
      if 5 == len && "working_online" ==  getContent(tds[len-1])
        puts getContent(tds[0])
      end
    end
  end

  def self.putsPre(pretable)
    begin
      trs = pretable.css("tr")
      puts getContent(trs[3].css("td")[2])
    rescue
      puts 'get pre exception'
    end
  end
end

doc = Nokogiri::HTML(open('http://pesystem.taobao.org:9999/app/' + appName = ARGV[0]));

pretable = doc.css('#tabPrepub table');
PeSystem.putsPre pretable

hoststable = doc.css('#tabHosts table');
PeSystem.putsOnline hoststable




