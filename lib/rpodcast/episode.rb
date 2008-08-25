module RPodcast
  class Episode
    attr_accessor :enclosure
    
    def self.parse_episodes(doc)
      episode_docs = []
      
      doc.elements.each('rss/channel/item') do |e|
        episode_docs << self.new(e)
      end

      episode_docs
    end

    def initialize(doc)
      @guid = doc.elements['guid'].text rescue nil
      @title = doc.elements['title'].text rescue nil
      @summary = doc.elements['description'].text rescue nil
      @summary ||= doc.elements['itunes:summary'].text rescue nil
      @published_at = Time.parse(doc.elements['pubDate'].text) rescue nil
      @enclosure = RPodcast::Enclosure.new(doc.elements['enclosure'].attributes)
    end
  end
end
