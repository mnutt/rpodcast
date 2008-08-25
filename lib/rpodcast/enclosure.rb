module RPodcast
  class Enclosure
    attr_accessor :url, :type, :size
    
    def initialize(element)
      @url = element['url']
      @type = element['type']
      @size = element['size']
    end
  end
end
