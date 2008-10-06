require 'open-uri'
require 'timeout'
require 'rexml/document'

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
      doc = REXML::Document.new(@content)

      FEED_ATTRIBUTES.each do |attribute|
        @attributes[attribute] = self.send("parse_#{attribute.to_s}", doc) rescue nil
      end

      doc
    end

    def parse_title(doc)
      get_text_from_element(doc, 'rss/channel/title')
    end

    def parse_link(doc)
      get_text_from_element(doc, 'rss/channel/link')
    end

    def parse_copyright(doc)
      get_text_from_element(doc, 'rss/channel/copyright')
    end

    def parse_image(doc)
      doc.elements.each('rss/channel/itunes:image') do |e|
        return e.attributes['href'] if e.attributes['href']
      end
      get_text_from_element(doc, 'rss/channel/image/url')
    end

    def parse_keywords(doc)
      doc.elements.each('rss/channel/itunes:keywords') do |e|
        return e.text.split(', ')
      end
    end

    def parse_categories(doc)
      categories = []
      doc.elements.each('rss/channel/itunes:category') do |e|
        categories << e.attributes['text']
      end
      doc.elements.each('rss/channel/itunes:category/itunes:category') do |e|
        categories << e.attributes['text']
      end
      categories.flatten.uniq
    end

    def parse_summary(doc)
      get_text_from_element(doc, 'rss/channel/itunes:summary')
    end

    def parse_language(doc)
      get_text_from_element(doc, 'rss/channel/language')
    end

    def parse_owner_email(doc)
      get_text_from_element(doc, 'rss/channel/itunes:owner/itunes:email')
    end

    def parse_owner_name(doc)
      get_text_from_element(doc, 'rss/channel/itunes:owner/itunes:name')
    end

    protected

      def method_missing(method, *args)
        if FEED_ATTRIBUTES.include?(method.to_sym)
          @attributes[method.to_sym]
        else
          super
        end
      end
      
      def get_text_from_element(doc, node)
        doc.elements.each(node) do |e|
          return e.text
        end
      end
  end
end
