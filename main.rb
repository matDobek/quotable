# gem install twitter
require 'twitter'
require 'yaml'
require 'pry'

class Strategy 
  def broadcast_file(_)
    fail NotImplementedError
  end

  def broadcast_text(_)
    fail NotImplementedError
  end
end

class TwitterStrategy < Strategy
  def initialize
    secrets = YAML.load_file('./secrets.yml')
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = secrets["consumer_key"]
      config.consumer_secret     = secrets["consumer_secret"]
      config.access_token        = secrets["access_token"]
      config.access_token_secret = secrets["access_token_secret"]
    end
  end

  def broadcast_file(file)
    client.update_with_media("", file)
  end

  def broadcast_text(text)
    client.update(text)
  end

  private

  attr_reader :client
end

class LogStrategy < Strategy
  def broadcast_file(file)
    puts "file"
  end

  def broadcast_text(text)
    puts text
  end
end

class Broadcast
  def self.file(f)
    LogStrategy.new.broadcast_file(f)
  end

  def self.text(str)
    LogStrategy.new.broadcast_text(str)
  end
end

class Quotable
  class << self
    def quote
      case rand(0..100) 
      when 99..100 then Broadcast.file(image)
      else Broadcast.text(text)
      end
    end

    private


    def image
      File.new(Dir["./quotes/*.jpg"].sample)
    end

    def text
      str = ""
      file = File.new(Dir["./books/*.txt"].sample)
      no_of_lines = `wc -l "#{file.path}"`.strip.split()[0].to_i
      no_of_sample_line = rand(0..no_of_lines)

      file.each_with_index do |line, number|
        next if number < no_of_sample_line

        line = line.strip
        while line.size > 100
          lines = line.split(".")
          lines.pop
          line = lines.join(".").strip
        end

        next if line.empty?
        next if line.size < 30

        book_name = file.path.split("/")[-1].split(".")[0].gsub("_", " ")
        str = "#{line}\n - #{book_name}"
        break
      end

      str
    end
  end
end

Quotable.quote
