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
    FEED_ATTRIBUTES = [:title, :subtitle, :link, :image, :summary, :language, 
                       :owner_email, :owner_name, :keywords, :categories, 
                       :copyright, :episodes, :bitrate, :format, :generator, 
                       :audio?, :video?, :explicit?, :hd?, :torrent?, 
                       :creative_commons?]
    
    attr_accessor :feed, :attributes

    def initialize(content, options={})
      @content = content
      @attributes = {}
    end

    def valid?
      @content =~ /<(\?xml|rss)/
    end

    def has_enclosure?
      @content =~ /\<enclosure/
    end
    
    def has_media_content?
      @content =~ /\<media\:content/
    end

    def parse
      raise InvalidXMLError  unless valid?
      raise NoEnclosureError unless has_enclosure? || has_media_content?

      h = Hpricot.XML(@content)

      FEED_ATTRIBUTES.each do |attribute|
        next unless respond_to?("parse_#{attribute}")
        @attributes[attribute] = self.send("parse_#{attribute}", h) rescue nil
      end

      @attributes[:bitrate]  = episodes.first.bitrate rescue 0
      @attributes[:audio?]   = !!(episodes.first.content_type =~ /^audio/) rescue false
      @attributes[:video?]   = !!(episodes.first.content_type =~ /^video/) rescue false
      @attributes[:hd?]      = video? ? bitrate > 1000 : bitrate > 180 rescue false
    end

    def parse_format(h)
      if episodes.first && episodes.first.enlcosure
        episode.first.enclosure.format
      elsif episodes.first && episodes.first.media_contents.size > 0
        episodes.first.media_contents.first.format
      else
        :unknown
      end
    end

    def parse_torrent?(h)
      if episodes.first && episodes.first.enlcosure
        episodes.first.enclosure.format.to_s == "torrent"
      elsif episodes.first && episodes.first.media_contents.size > 0
        episodes.first.media_contents.first.format.to_s == "torrent"
      else
        false
      end
    end

    def parse_creative_commons?(h)
      !!((h % 'rss')['xmlns:creativecommons']) rescue false
    end

    def parse_title(h)
      (h % 'title').inner_text
    end

    def parse_subtitle(h)
      (h % 'itunes:subtitle').inner_text
    end

    def parse_explicit?(h)
      !!((h % 'itunes:explicit').inner_html =~ /yes/)
    end

    def parse_link(h)
      (h % 'link').inner_html
    end

    def parse_copyright(h)
      copyright = (h % 'copyright').inner_text rescue nil
      return copyright unless copyright.nil? or copyright == ""

      copyright = (h % 'media:copyright').inner_text rescue nil
      return copyright unless copyright.nil? or copyright == ""
    end

    def parse_image(h)
      image = (h % 'itunes:image')['href'] rescue nil
      return image unless image.nil? or image == ""
      
      image = (h % 'image' % 'url').inner_html rescue nil
      return image unless image.nil? or image == ""
    end

    def parse_keywords(h)
      keywords = (h % 'itunes:keywords').inner_text.split(/[\s]*,[\s]*/).map{|k| k.strip} rescue nil
      return keywords unless keywords.nil? or keywords.empty?

      keywords = (h % 'media:keywords').inner_text.split(/[\s]*,[\s]*/).map{|k| k.strip} rescue nil
      return keywords
    end

    def parse_categories(h)
      (h / 'itunes:category').map {|e| e[:text] }.uniq
    end

    def parse_summary(h)
      d = (h % 'description').inner_html rescue ''
      s = (h % 'itunes:summary').inner_html rescue ''
      
      [d, s].max { |a,b| a.length <=> b.length }
    end

    def parse_language(h)
      (h % 'language').inner_text
    end

    def parse_generator(h)
      (h % 'generator').inner_text
    end

    def parse_owner_email(h)
      (h % 'itunes:email').inner_text
    end

    def parse_owner_name(h)
      owner = (h % 'itunes:name').inner_text rescue nil
      return owner unless owner.nil? or owner == ""
      
      owner = (h % 'itunes:author').inner_text rescue nil
      return owner unless owner.nil? or owner == ""
    end

    def parse_episodes(h)
      (h / 'item').map {|e| 
        begin
          Episode.new(e)
        rescue => e
          puts "\nthe episode error was #{e.inspect}\n"
          nil
        end }.compact
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
