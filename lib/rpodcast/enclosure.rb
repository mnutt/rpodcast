module RPodcast
  class Enclosure
    attr_accessor :url, :type, :size
    
    def initialize(element)
      @url = element['url'] rescue nil
      @type = element['type'] rescue nil
      @size = (element['size'] or element['length']).to_i rescue nil
    end
  end
end
