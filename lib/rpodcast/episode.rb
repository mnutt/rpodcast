module RPodcast
  class Episode
    EPISODE_ATTRIBUTES = [:guid, :title, :summary, :published_at, :enclosure]

    attr_accessor :attributes
    
    def self.parse(content)
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
      @attributes[:enclosure] = RPodcast::Enclosure.new(doc.elements['enclosure'].attributes)
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
