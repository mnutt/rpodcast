require 'open-uri'
require 'timeout'
require 'rexml/document'

module RPodcast
  class PodcastError < StandardError; end

  class Feed
    FEED_ATTRIBUTES = [:title, :link, :image, :summary, :language, :owner_email, :owner_name]
    
    attr_accessor :url, :feed, :episodes, :attributes

    def initialize(url, options={})
      @url = url
      @attributes = {}
      @episodes = []

      @feed = is_url? ? feed_from_url : feed_from_path
      @doc = parse_feed

      unless @feed.nil?
        @episodes = RPodcast::Episode.parse_episodes(@doc)
      end
    end

    def is_url?
      @url =~ /^http:\/\/([^\/]+)\/(.*)/
    end

    def parse_feed
      doc = REXML::Document.new(@feed)
      raise PodcastError, "This is not a podcast feed. Try again." unless REXML::XPath.first(doc, "//enclosure")

      FEED_ATTRIBUTES.each do |attribute|
        @attributes[attribute] = self.send("parse_#{attribute.to_s}", doc) rescue nil
      end

      doc
    end

    def parse_title(doc)
      doc.elements.each('rss/channel/title') do |e|
        return e.text
      end
    end

    def parse_link(doc)
      doc.elements.each('rss/channel/link') do |e|
        return e.text
      end
    end

    def parse_image(doc)
      doc.elements.each('rss/channel/itunes:image') do |e|
        return e.attributes['href']
      end
    end

    def parse_summary(doc)
      doc.elements.each('rss/channel/itunes:summary') do |e|
        return e.text
      end
    end

    def parse_language(doc)
      doc.elements.each('rss/channel/language') do |e|
        return e.text
      end
    end

    def parse_owner_email(doc)
      doc.elements.each('rss/channel/itunes:owner/itunes:email') do |e|
        return e.text
      end
    end

    def parse_owner_name(doc)
      doc.elements.each('rss/channel/itunes:owner/itunes:name') do |e|
        return e.text
      end
    end

    def feed_from_url      
      Timeout::timeout(5) do
        OpenURI::open_uri(@url) do |f|
          f.read
        end
      end
    rescue Timeout::Error
      raise PodcastError, "Not found. (timeout) Try again."
    rescue Errno::ENETUNREACH
      raise PodcastError, "Not found. Try again."
    rescue StandardError => e
      raise PodcastError, "Weird server error. Try again."
    end

    def feed_from_path
      File.open(@url) do |f|
        f.read
      end
    end

    def method_missing(method, *args)
      if FEED_ATTRIBUTES.include?(method.to_sym)
        @attributes[method.to_sym]
      else
        super
      end
    end
  end
end
