# http://combinificator.com
module RPodcast
  class CombinificatorSource
    attr_accessor :url, :enclosure, :is_primary

    def initialize(element)
      @url = element['url']
      @enclosure = RPodcast::Enclosure.new(element.at('combinificator:enclosure'), nil)
      @is_primary = !['false', '0', ''].include?(element['isPrimary'].to_s.downcase)
    end
    
    def is_primary?
      @is_primary
    end
  end
end
