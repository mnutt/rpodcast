module RPodcast
  class Episode
    EPISODE_ATTRIBUTES = [:guid, :title, :summary, :published_at, :enclosure, :duration]

    attr_accessor :attributes, :enclosure
    
    def self.parse(content)
      RPodcast::Feed.validate_feed(content)

      @doc = REXML::Document.new(content)
      episode_docs = []
      
      @doc.elements.each('rss/channel/item') do |e|
        episode_docs << self.new(e)
      end

      episode_docs
    end

    def initialize(doc)
      @attributes = Hash.new
      @attributes[:guid] = doc.elements['guid'].text rescue nil
      @attributes[:title] = doc.elements['title'].text rescue nil
      @attributes[:summary] = doc.elements['description'].text rescue nil
      @attributes[:summary] ||= doc.elements['itunes:summary'].text rescue nil
      @attributes[:published_at] = Time.parse(doc.elements['pubDate'].text) rescue nil

      begin
        # Time may be under an hour
        time = doc.elements['itunes:duration'].text
        time = "00:#{time}" if time.size < 6
        time_multiplier = [24 * 60, 60, 1]
        @attributes[:duration] = time.split(":").map { |t| 
          seconds = t.to_i * time_multiplier[0]
          time_multiplier.shift
          seconds
        }.sum 
      rescue 
        @attributes[:duration] = 0
      end

      @enclosure = RPodcast::Enclosure.new(doc.elements['enclosure'].attributes)
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
