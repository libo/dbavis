#!/usr/bin/ruby

# Usage:
# ruby script.rb email-to-notify@example.com

require 'wombat'
require 'digest'
require 'json'

WEB_PATH = "/mobil-og-telefoni/mobiltelefoner-og-tilbehoer/mobiltelefoner/maerke-google/" +
 "?soeg=pixel&fra=privat&sort=listingdate-desc".freeze

class Item
  include Wombat::Crawler

  base_url "http://www.dba.dk/"
  path WEB_PATH

  items "css=table.searchResults tr.dbaListing", :iterator do |node|
    name "css=td.mainContent script" do |payload|
      JSON.parse(payload.gsub(/\n/, ''))['name']
    end

    url "css=td.mainContent script" do |payload|
      JSON.parse(payload.gsub(/\n/, ''))['url']
    end

    price "css=td.mainContent script" do |payload|
      JSON.parse(payload.gsub(/\n/, ''))['offers']['price']
    end
  end
end

def notify(item)
  to = ARGV[0]
  subject = "Something new on dba"
  content = "#{item.name}\n\n#{item.price}\n\n#{item.price}"
  `mail -s "#{subject}" #{to}<<EOM
    #{content}
  EOM`
  sleep(2) # Do not flood email server (I use a free Amazon SES)
end

items = Item.new.crawl["items"]

items.each do |item|
  id = Digest::MD5.hexdigest(item['url'])
  filename = File.join(Dir.pwd, "logs", "#{id}.log")

  unless File.file?(filename)
    File.open(filename, 'w') do |file|
      file.write(item.to_json)
    end

    notify(item) if ARGV[0]
  end
end
