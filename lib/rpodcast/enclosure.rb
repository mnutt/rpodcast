module RPodcast
  class Enclosure
    attr_accessor :url, :content_type, :size, :format

    @@content_types = {
      "video/avi"       => :avi,
      "video/msvideo"   => :avi,
      "video/x-msvideo" => :avi,
      "video/divx"      => :divx,
      "video/mp4"       => :m4v,
      "video/mpeg"      => :mpg,
      "video/quicktime" => :mov,
      "video/x-m4v"     => :m4v,
      "video/x-mpeg"    => :mpg,
      "video/x-ms-wmv"  => :wmv,
    }.freeze

    def initialize(element)
      @url          = element['url'] rescue nil
      @content_type = element['type'] rescue nil
      @size         = (element['size'] or element['length'] or element['fileSize']).to_i rescue nil
      @format       = self.extension || @@content_types[self.content_type] || :unknown
    end

    def extension
      $1 if @url.split('.').last =~ /([a-z0-9]*)/i rescue ""
    end
  end
end
