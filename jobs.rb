require 'net/http'
require 'open-uri'
require 'twitter'
require 'tumblr'

class Jobs

  Dir.mkdir(File.join(File.dirname(__FILE__), "log")) unless Dir.exists?(File.join(File.dirname(__FILE__), "log"))
  @@log_file = File.open(File.join(File.dirname(__FILE__), "log/#{ENV['RACK_ENV']}.log"), 'a')
  @@log_file.sync = true
  def log(msg)
    line = "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n"
    @@log_file.write(line)
    puts line
  end

  def echo
    log "START at #{Time.now.strftime('%Y%m%d %T')}"
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    tumblr = Tumblr::REST::Client.new do |config|
      config.consumer_key        = ENV['TUMBLR_CONSUMER_KEY']
      config.consumer_secret     = ENV['TUMBLR_CONSUMER_SECRET']
      config.access_token        = ENV['TUMBLR_ACCESS_TOKEN']
      config.access_token_secret = ENV['TUMBLR_ACCESS_TOKEN_SECRET']
    end

    twitter.mentions_timeline(result_type: "recent").take(100).each do |tweet|
      tumblr.text(tweet.tweet)
    end
  end

end
