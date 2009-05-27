require 'cgi'

module RPodcast
  class Episode
    EPISODE_ATTRIBUTES = [:guid, :title, :summary, :published_at, :enclosure, :media_contents, :duration, :bitrate, :hashes]

    attr_accessor :attributes, :enclosure, :media_contents, :raw_xml
    
    def initialize(el)
      @attributes = Hash.new
      @attributes[:guid] = el.at('guid').inner_html rescue nil
      @attributes[:title] = (el.at('title') || el.at('media:title')).inner_html.gsub(/\<\!\[CDATA\[(.*)\]\]\>/, '\1') rescue nil
      @attributes[:summary] = (el.at('description') || el.at('itunes:summary') || el.at('media:description')).inner_html.gsub(/\<\!\[CDATA\[(.*)\]\]\>/, '\1') rescue nil
      @attributes[:published_at] = Time.parse(el.at('pubDate').inner_html) rescue nil
    
      # We'll scan for the possibility of included MRSS hashes, ie hashes[:md5] #=> 'as23ada123...'
      @attributes[:hashes] = {}
      (el / 'media:hash').each { |hash| @attributes[:hashes][hash[:algo]] = hash.inner_html }
      
      begin
        # Time may be under an hour
        time = el.at('itunes:duration').inner_html
        time = "00:#{time}" if time.size < 6
        time_multiplier = [24 * 60, 60, 1]
        @attributes[:duration] = time.split(":").map { |t| 
          seconds = t.to_i * time_multiplier[0]
          time_multiplier.shift
          seconds
        }.inject(0) {|m,n| m+n}
      rescue
        begin
          # Checking for MRSS
          @attributes[:duration] = (el % 'media:content')[:duration].to_i
        rescue
          @attributes[:duration] = 0
        end
      end

      # episode's raw XML snippet
      @raw_xml = el.to_html

      @enclosure = RPodcast::Enclosure.new(el.at('enclosure'))
      @media_contents = (el / 'media:content').to_a.map {|mc| RPodcast::MediaContent.new(mc)}

      @attributes[:bitrate] = (((@enclosure.size || (@media_contents[0].size rescue 0)) * 8) / 1000.0) / @attributes[:duration]
      @attributes[:bitrate] = 0 unless @attributes[:bitrate].finite?

      unescape! :summary, :title
    end

    protected
    # unescape twice in case the podcaster is double-escaping html entities
    def unescape!(*attrs)
      attrs.each do |attr|
        @attributes[attr] = CGI::unescapeHTML(CGI::unescapeHTML(@attributes[attr])) unless @attributes[attr].nil?
      end
    end


    def method_missing(method, *args)
      if EPISODE_ATTRIBUTES.include?(method.to_sym)
        @attributes[method.to_sym]
      else
        super
      end
    end
  end
end
