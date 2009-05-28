module RPodcast
  class MediaContent
    attr_accessor :url, :content_type, :size, :format, :episode, 
                  :bitrate, :duration

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

    def initialize(element, episode)
      @episode      = episode
      @duration     = element['duration'] rescue nil
      @url          = element['url'] rescue nil
      @content_type = element['type'] rescue nil
      @size         = element['fileSize'].to_i rescue nil
      @format       = self.extension || @@content_types[self.content_type] || :unknown
      @bitrate      = (((@size || 0) * 8) / 1000.0) / (@duration || @episode.duration).to_f
      @bitrate      = 0 unless @bitrate.finite?
    end

    def extension
      $1 if @url.split('.').last =~ /([a-z0-9]*)/i rescue ""
    end
  end
end
