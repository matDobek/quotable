# gem install twitter
require 'twitter'
require 'yaml'
require 'pry'

secrets = YAML.load_file('./secrets.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = secrets["consumer_key"]
  config.consumer_secret     = secrets["consumer_secret"] 
  config.access_token        = secrets["access_token"]
  config.access_token_secret = secrets["access_token_secret"]
end

file = File.new(Dir["./quotes/*.jpg"].sample)
client.update_with_media("", file)
