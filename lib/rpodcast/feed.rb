require 'open-uri'
require 'timeout'
require 'hpricot'

module RPodcast
  class PodcastError < StandardError; end
  class InvalidXMLError < PodcastError; end
  class NoEnclosureError < PodcastError; end
  # other exceptions that might be helpful, but not explicitly used here
  class InvalidAddressError < PodcastError; end
  class BannedFeedError < PodcastError; end

  class Feed
    FEED_ATTRIBUTES = [:title, :link, :image, :summary, :language, :owner_email, :owner_name, :keywords, :categories]
    
    attr_accessor :feed, :episodes, :attributes

    def self.validate_feed(content)
      raise InvalidXMLError unless content =~ /^[\s]*<\?xml/
      raise NoEnclosureError unless content =~ /\<enclosure/
    end

    def initialize(content, options={})
      @content = content
      @attributes = {}
      @episodes = []

      Feed.validate_feed(@content)

      @doc = parse_feed

      unless @content.nil?
        @episodes = RPodcast::Episode.parse(@content)
      end
    end

    def parse_feed
      doc = Hpricot.XML(@content)

      FEED_ATTRIBUTES.each do |attribute|
        @attributes[attribute] = self.send("parse_#{attribute.to_s}", doc) rescue nil
      end

      doc
    end

    def parse_title(doc)
      (doc/'rss'/'channel'%'title').inner_html
    end

    def parse_link(doc)
      (doc/'rss'/'channel'%'link').inner_html
    end

    def parse_copyright(doc)
      (doc/'rss'/'channel'%'copyright').inner_html
    end

    def parse_image(doc)
      (doc/'rss'/'channel'/'itunes:image').each do |e|
        return e['href'] if e['href']
      end
      (doc/'rss'/'channel'/'image'%'url').inner_html
    end

    def parse_keywords(doc)
      (doc/'rss'/'channel'/'itunes:keywords').each do |e|
        return e.inner_html.split(', ')
      end
    end

    def parse_categories(doc)
      categories = []
      (doc/'rss'/'channel'/'itunes:category').each do |e|
        categories << e['text']
      end
      (doc/'rss'/'channel'/'itunes:category'/'itunes:category').each do |e|
        categories << e['text']
      end
      categories.flatten.uniq
    end

    def parse_summary(doc)
      (doc/'rss'/'channel'%'itunes:summary').inner_html
    end

    def parse_language(doc)
      (doc/'rss'/'channel'%'language').inner_html
    end

    def parse_owner_email(doc)
      (doc/'rss'/'channel'/'itunes:owner'%'itunes:email').inner_html
    end

    def parse_owner_name(doc)
      (doc/'rss'/'channel'/'itunes:owner'%'itunes:name').inner_html
    end

    protected

      def method_missing(method, *args)
        if FEED_ATTRIBUTES.include?(method.to_sym)
          @attributes[method.to_sym]
        else
          super
        end
      end
  end
end
