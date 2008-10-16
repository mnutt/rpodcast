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
    FEED_ATTRIBUTES = [:title, :link, :image, :summary, :language, :owner_email, :owner_name, :keywords, :categories, :episodes, :bitrate, :format]
    
    attr_accessor :feed, :attributes

    def self.validate_feed(content)
      raise InvalidXMLError unless content =~ /^[\s]*<\?xml/
      raise NoEnclosureError unless content =~ /\<enclosure/
    end

    def initialize(content, options={})
      @content = content
      @attributes = {}

      Feed.validate_feed(@content)

      self.parse_feed
    end

    def parse_feed
      h = Hpricot.XML(@content)

      FEED_ATTRIBUTES.each do |attribute|
        @attributes[attribute] = self.send("parse_#{attribute}", h) rescue nil
      end

      @attributes[:bitrate] = self.episodes.map {|e| e.bitrate }.inject(0){|m,n| m + n} / self.episodes.size
      @attributes[:format]  = self.episodes.first.enclosure.format rescue :unknown
    end

    def parse_title(h)
      (h % 'title').inner_html
    end

    def parse_link(h)
      (h % 'link').inner_html
    end

    def parse_copyright(h)
      (h % 'copyright').inner_html
    end

    def parse_image(h)
      (h % 'itunes:image')['href'] || (h % 'image' % 'url').inner_html
    end

    def parse_keywords(h)
      (h % 'itunes:keywords').inner_html.split(', ')
    end

    def parse_categories(h)
      (h / 'itunes:category').map {|e| e[:text] }.uniq
    end

    def parse_summary(h)
      (h % 'itunes:summary').inner_html
    end

    def parse_language(h)
      (h % 'language').inner_html
    end

    def parse_owner_email(h)
      (h % 'itunes:email').inner_html
    end

    def parse_owner_name(h)
      (h % 'itunes:name').inner_html
    end

    def parse_episodes(h)
      (h / 'item').map {|e| Episode.new(e) }
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
