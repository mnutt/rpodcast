module RPodcast
  class Enclosure
    attr_accessor :url, :type, :size, :format

    @@content_types = {
      "video/avi"       => :avi,
      "video/msvideo"   => :avi,
      "video/x-msvideo" => :avi,
      "video/divx"      => :divx,
      "video/mp4"       => :quicktime,
      "video/mpeg"      => :quicktime,
      "video/quicktime" => :quicktime,
      "video/x-m4v"     => :quicktime,
      "video/x-mpeg"    => :quicktime,
      "video/x-ms-wmv"  => :wmv,
    }.freeze
    @@file_extensions = {
      "flv" => :flash,
      "mp3" => :mp3,
      "m4v" => :quicktime,
      "mov" => :quicktime,
      "mp4" => :quicktime,
      "mpg" => :quicktime,
      "wma" => :wma,
      "wmv" => :wmv,
    }.freeze

    def initialize(element)
      @url    = element['url'] rescue nil
      @type   = element['type'] rescue nil
      @size   = (element['size'] or element['length']).to_i rescue nil
      @format = @@content_types[self.type] || @@file_extensions[self.extension] || :unknown
    end

    def extension
      $1 if @url.split('.').last =~ /([a-z0-9]*)/i rescue ""
    end
  end
end
