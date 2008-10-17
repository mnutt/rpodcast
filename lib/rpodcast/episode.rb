module RPodcast
  class Episode
    EPISODE_ATTRIBUTES = [:guid, :title, :summary, :published_at, :enclosure, :duration, :bitrate]

    attr_accessor :attributes, :enclosure
    
    def initialize(el)
      @attributes = Hash.new
      @attributes[:guid] = el.at('guid').inner_html rescue nil
      @attributes[:title] = el.at('title').inner_html rescue nil
      @attributes[:summary] = el.at('description').inner_html rescue nil
      @attributes[:summary] ||= el.at('itunes:summary').inner_html rescue nil
      @attributes[:published_at] = Time.parse(el.at('pubDate').inner_html) rescue nil

      begin
        # Time may be under an hour
        time = el['itunes:duration'].inner_html
        time = "00:#{time}" if time.size < 6
        time_multiplier = [24 * 60, 60, 1]
        @attributes[:duration] = time.split(":").map { |t| 
          seconds = t.to_i * time_multiplier[0]
          time_multiplier.shift
          seconds
        }.sum 
      rescue 
        begin
          @attributes[:duration] = (el % 'media:content')[:duration].to_i
        rescue
          @attributes[:duration] = 0
        end
      end

      @enclosure = RPodcast::Enclosure.new(el.at('enclosure'))

      @attributes[:bitrate] = ((@enclosure.size * 8) / 1000.0) / @attributes[:duration]
      @attributes[:bitrate] = 0 unless @attributes[:bitrate].finite?
    end

    protected

    def method_missing(method, *args)
      if EPISODE_ATTRIBUTES.include?(method.to_sym)
        @attributes[method.to_sym]
      else
        super
      end
    end
  end
end
