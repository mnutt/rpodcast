require File.dirname(__FILE__) + '/../spec_helper'

describe RPodcast::Feed, "1upshow" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', '1upshow.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "The 1UP Show"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "1UP editors report on the videogame industry and the community that surrounds it. PS3, Wii, Xbox 360, PC, PS2, Xbox, GameCube, PSP, GBA, DS, Wireless. 1UP.com, Electronic Gaming Monthly, Official U.S. PlayStation Magazine, Games For Windows"
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://the1upshow.1up.com/"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://www.1up.com/flat/Podcasts/1upvideo300x300.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^Welcome to 1UP's new weekly show on the latest and grea/
  end

  it 'should extract the owner email' do
    @podcast.owner_email.should == "dnguyen@1up.com"
  end

  it 'should extract the owner name' do
    @podcast.owner_name.should == "Duong Nguyen"
  end

  it 'should extract the language' do
    @podcast.language.should == "en-us"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == nil
  end

  it 'should have episodes' do
    @podcast.episodes.size.should == 20
  end

  it 'should have an episode with a title' do
    @podcast.episodes.first.title.should == "The 1UP Show: Episode 151 - 08/22/2008"
  end

  it 'should have an episode with a summary' do
    @podcast.episodes.first.summary.should =~ /^Rock Band 2, Ratchet and Clank/
  end

  it 'should have an episode with an enclosure with a URL' do
    @podcast.episodes.first.enclosure.url.should == "http://www.podtrac.com/pts/redirect.mp3/download.gamevideos.com/Podcasts/082208.m4v"
  end

  it 'should have an episode with an enclosure with a size' do
    @podcast.episodes.first.enclosure.size.should == 504725956
  end
end

describe RPodcast::Feed, "diggnation" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'diggnation.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "Diggnation (Large WMV)"
  end
  
  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Diggnation is a weekly tech/web culture show based on the top digg.com social bookmarking news stories."
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://revision3.com/diggnation"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://bitcast-a.bitgravity.com/revision3/images/shows/diggnation/diggnation.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^Diggnation is a weekly tech\/web culture show/
  end

  it 'should extract the owner email' do
    @podcast.owner_email.should == "feedback@revision3.com"
  end

  it 'should extract the owner name' do
    @podcast.owner_name.should == "Revision3"
  end

  it 'should extract the language' do
    @podcast.language.should == "en-us"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == nil
  end

  describe "first episode" do

    it 'should have a title' do
      @podcast.episodes.first.title.should =~ /Diggnation - Prager/
    end
    
    it 'should extract the subtitle' do
      @podcast.episodes.first.subtitle.strip.should == "Creative Business Card Designs, Early Dark Knight Concept Art Shows a Much Creepier Joker, This Guy Actually Bought the I Am Rich App for $999.99, Ikea to Start Selling Solar Panels, Slow Motion Lightning Video is Mindblowing. LIVE SHOW ON TUESDAY AUG 26"
    end

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 2679
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.to_i.should == 1311
      @podcast.episodes.first.enclosure.bitrate.to_i.should == 1311
    end

    it 'should have a url' do
      @podcast.episodes.first.enclosure.url.should == "http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0164/diggnation--0164--2008-08-21polepoll--large.wmv9.wmv"
    end
  end

end


describe RPodcast::Feed, "diggnation (w/only MRSS)" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'diggnation_only_mrss.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "Diggnation (Large WMV)"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Diggnation is a weekly tech/web culture show based on the top digg.com social bookmarking news stories."
  end

  describe "first episode" do

    it 'should have a title' do
      @podcast.episodes.first.title.should =~ /Diggnation - Prager/
    end
    
    it 'should have a subtitle' do
      @podcast.episodes.first.subtitle.should =~ /Creative Business Card Designs,/
    end
    
    it 'should have a summary' do
      @podcast.episodes.first.summary.strip.should == "\nCreative Business Card Designs, Early Dark Knight Concept Art Shows a Much Creepier Joker, This Guy Actually Bought the I Am Rich App for $999.99, Ikea to Start Selling Solar Panels, Slow Motion Lightning Video is Mindblowing. <span style=\"color: #FF0000\">LIVE SHOW ON TUESDAY AUG 26TH!!!</span>".strip
    end

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 2679
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.to_i.should == 1311
      @podcast.episodes.first.enclosure.bitrate.to_i.should == 0
    end

    it 'should have a hash' do
      @podcast.episodes.first.hashes['md5'].should == 'this_is_a_fake_md5_hash'
    end
  end

end

describe RPodcast::Feed, "diggnation (funneled)" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'diggnation_funnel.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "Diggnation"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Diggnation is a weekly tech/web culture show based on the top digg.com social bookmarking news stories."
  end

  it 'should have array of urls from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.url }.should == [
      "http://revision3.com/diggnation/feed/mp4-hd30/", 
      "http://revision3.com/diggnation/feed/quicktime-high-definition/", 
      "http://revision3.com/diggnation/feed/quicktime-large/", 
      "http://revision3.com/diggnation/feed/quicktime-small/", 
      "http://revision3.com/diggnation/feed/wmv-large/", 
      "http://revision3.com/diggnation/feed/wmv-small/", 
      "http://revision3.com/diggnation/feed/xvid-large/", 
      "http://revision3.com/diggnation/feed/xvid-small/", 
      "http://revision3.com/diggnation/feed/mp3/"
    ]
  end

  it 'should have array of enclosure urls from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.enclosure.url }.should == [
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--hd720p30.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--hd.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--small.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.wmv9.wmv", 
      "http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--small.wmv9.wmv", 
      "http://www.podtrac.com/pts/redirect.avi/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.xvid.avi", 
      "http://www.podtrac.com/pts/redirect.avi/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--small.xvid.avi", 
      "http://www.podtrac.com/pts/redirect.mp3/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.lame.mp3"
    ]
  end

  it 'should have array of sizes from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.enclosure.size }.should == [
      568539428, 476982528, 385712306, 135318410, 385987610, 147700570, 330597352, 214916040, 37923840
    ]
  end

  it 'should have array of durations from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.enclosure.duration.to_i }.should == [
      2316, 2316, 2316, 2316, 2316, 2316, 2316, 2316, 2316
    ]
  end

  it 'should have array of urls from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.enclosure.url }.should == [
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--hd720p30.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--hd.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--small.h264.mp4", 
      "http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.wmv9.wmv", 
      "http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--small.wmv9.wmv", 
      "http://www.podtrac.com/pts/redirect.avi/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.xvid.avi", 
      "http://www.podtrac.com/pts/redirect.avi/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--small.xvid.avi", 
      "http://www.podtrac.com/pts/redirect.mp3/bitcast-a.bitgravity.com/revision3/web/diggnation/0219/diggnation--0219--handmade--large.lame.mp3"
    ]
  end

  it 'should have array of extensions from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.enclosure.extension }.should == [
      "mp4", "mp4", "mp4", "mp4", "wmv", "wmv", "avi", "avi", "mp3"
    ]
  end

  it 'should have an array of enclosure is_primary? booleans from combinificator:sources' do
    @podcast.combinificator_sources.map { |s| s.is_primary? }.should == [false, false, false, false, false, false, false, false, true]
  end

  describe "first episode" do

    it 'should have a title' do
      @podcast.episodes.first.title.should =~ /Poolside at Night in Arizona - Diggnation/
    end
    
    it 'should have a subtitle' do
      @podcast.episodes.first.subtitle.should =~ /Coming straight from the infamous Phoenix heat/
    end
    
    it 'should have a summary' do
      @podcast.episodes.first.summary.strip.should =~ /Coming straight from the infamous Phoenix heat/
    end

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 0
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.to_i.should == 0
      @podcast.episodes.first.enclosure.bitrate.to_i.should == 0
    end
    
    it 'should have a media:group' do
      @podcast.episodes.first.media_contents.map { |mc| mc.url }.should == %w(
      http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--large.h264.mp4
      http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--small.wmv9.wmv
      http://www.podtrac.com/pts/redirect.avi/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--small.xvid.avi
      http://www.podtrac.com/pts/redirect.avi/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--large.xvid.avi
      http://www.podtrac.com/pts/redirect.wmv/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--large.wmv9.wmv
      http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--hd.h264.mp4
      http://www.podtrac.com/pts/redirect.mp3/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--large.lame.mp3
      http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--hd720p30.h264.mp4
      http://www.podtrac.com/pts/redirect.mp4/bitcast-a.bitgravity.com/revision3/web/diggnation/0218/diggnation--0218--phoenixhotel--small.h264.mp4)
    end
  end

end

describe RPodcast::Feed, "powdertravel" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'powderpodcast.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "-Ski & Snowboard Travel Show- (video) powdertravel.com"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Ski & Snowboard Travel Show - powdertravel.com"
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://www.powdertravel.com"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://www.powdertravel.com/itunes300_powder.png"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^Skiing/
  end

  it 'should extract the owner email' do
    @podcast.owner_email.should == "paul@powdertravel.com"
  end

  it 'should extract the owner name' do
    @podcast.owner_name.should == "powdertravel.com"
  end

  it 'should extract the language' do
    @podcast.language.should == "EN"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == nil
  end

  describe "first episode" do

    it 'should have a title' do
      @podcast.episodes.first.title.should =~ /Davos Review/
    end

    it 'should have a subtitle' do
      @podcast.episodes.first.subtitle.should == "Davos Review / Ski &amp; Snowboard Travel Show episode Forty Five"
    end

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 308
    end

    it 'should not have a bitrate' do # they have incorrect sizes
      @podcast.episodes.first.bitrate.to_i.should == 0
      @podcast.episodes.first.enclosure.bitrate.to_i.should == 0
    end

    it 'should have a size' do # which is incorrect
      @podcast.episodes.first.enclosure.size.should == 5008
    end

    it 'should have a url' do
      @podcast.episodes.first.enclosure.url.should == "http://www.powdertravel.com/ep45_davos_review.m4v"
    end
  end
end

describe RPodcast::Feed, "macbreak" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'macbreak.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "MacBreak (HD video)"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "The first hi-def IPTV show all about the Mac"
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://pixelcorps.tv/macbreak"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://libsyn.com/podcasts/macbreak/images/mb_fulllogo.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^The only Macintosh/
  end

  it 'should extract the owner email' do
    @podcast.owner_email.should == "info@macbreak.com"
  end

  it 'should extract the owner name' do
    @podcast.owner_name.should == "The MacBreak Team"
  end

  it 'should extract the language' do
    @podcast.language.should == "en"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == "Pixel Corps Feed Generator"
  end

  describe "first episode" do

    it 'should have a title' do
      @podcast.episodes.first.title.should =~ /MacBreak 166/
    end

    it 'should have a subtitle' do
      @podcast.episodes.first.subtitle.should =~ /Alex explains the advantages of using Tubemogul to upload and track your online media./
    end

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 160
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.should == 1646.6225
      @podcast.episodes.first.enclosure.bitrate.should == 1646.6225
    end

    it 'should have a size' do
      @podcast.episodes.first.enclosure.size.should == 32932450
    end

    it 'should have a url' do
      @podcast.episodes.first.enclosure.url.should == "http://www.podtrac.com/pts/redirect.mov/pixelcorps.cachefly.net/macbreak_166_540p_h264.mov"
    end
  end
end


describe RPodcast::Feed, "Sam Downie's Tech:Casts" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'tech_casts.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "Sam Downie's Tech:Casts"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Unique Technology interviews from the UK - Give it a listen!"
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://techcasts.podOmatic.com"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://techcasts.podOmatic.com/mymedia/thumb/8006/0x0_599910.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^Unique Technology interviews about Apple Computer and it's users. Sam Downie brings 16 years of being a Apple User and 6 years of radio work to the Mac world. If you've heard him before you know what to expect... interviews, commentary, guests. If you haven't heard him, then welcome to Sam's look at all things Apple and Apple related news. Reporting from the UK, the USA and around the world. - Give it a listen!/
  end

  it 'should extract the language' do
    @podcast.language.should == "en-us"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == "podOmatic RSS Generator"
  end

  it 'should have episodes' do
    @podcast.episodes.size.should == 16
  end

  it 'should have an episode with a title that has decoded html entities' do
    @podcast.episodes[1].title.should == "Guide to Macworld Conference & Expo 2008"
  end

  it 'should have an episode with no subtitle' do
    @podcast.episodes[1].subtitle.should == nil
  end

  it 'should have an episode with a summary' do
    @podcast.episodes[1].summary.should =~ /^\<img src\=\"http\:\/\/techcasts.podOmatic.com\/mymedia\/thumb\/8006\/0x0_626433\.png\" alt\=\"itunes pic\" \/\>/
  end

  it 'should have an episode with an enclosure with a URL' do
    @podcast.episodes[1].enclosure.url.should == "http://techcasts.podOmatic.com/enclosure/2007-12-17T10_25_28-08_00.mp3"
  end

  it 'should have an episode with an enclosure with a size' do
    @podcast.episodes[1].enclosure.size.should == 16662778
  end
  
  it 'should have an episode with a duration' do
    @podcast.episodes[1].duration.should == 1525
  end
end

describe RPodcast::Feed, "BoingBoing" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'boingboing.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "Boing Boing TV"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Boing Boing TV"
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://tv.boingboing.net/"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://tv.boingboing.net/mtimages/bb-itunes-300.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^From the editors of Boing Boing/
  end

  it 'should extract the keywords' do
    @podcast.keywords.should == ["boingboing", "Boing", "technology", "eclectic", 
                                 "Xeni", "Jardin", "Mark", "Frauenfelder", "Cory", 
                                 "Doctorow", "David", "Pescovitz"]
  end

  it 'should extract the copyright' do
    @podcast.copyright.should == "Copyright 2008"
  end

  it 'should extract the language' do
    @podcast.language.should == "en"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == "http://www.sixapart.com/movabletype/"
  end

  it 'should have episodes' do
    @podcast.episodes.size.should == 30
  end

  it 'should have an episode with a title that has decoded html entities' do
    @podcast.episodes[1].title.should == "Unicorn Chaser: Joel Johnson of Boing Boing Gadgets in\n      \"UHHHHHH.\""
  end

  it 'should have an episode with a subtitle' do
    @podcast.episodes[1].subtitle.should =~ /Boing Boing Gadgets editor Joel Johnson/
  end

  it 'should have an episode with a summary' do
    @podcast.episodes[1].summary.should =~ /after Joel was nearly bitten by a snake/
  end

  it 'should have an episode with an enclosure with a URL' do
    @podcast.episodes[1].enclosure.url.should == "http://feeds.boingboing.net/~r/boingboing/tv/~5/468487598/unicorn-chaser-uhhhh-joelboing-boing-gadgets.mp4"
  end

  it 'should have an episode with no size' do
    @podcast.episodes[1].enclosure.size.should == 0
  end
  
  it 'should have an episode with no duration' do
    @podcast.episodes[1].duration.should == 0
  end
end

# This one has junk characters at the beginning and wasn't registering as a real rss feed
describe RPodcast::Feed, "Investment Real Estate" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'investment.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should be an rpodcast object' do
    @podcast.should be_kind_of(RPodcast::Feed)
  end

  it 'should extract the title' do
    @podcast.title.should == "Investment Real Estate Podcast"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == ""
  end
end

describe RPodcast::Feed, "ActsAsConference2009" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'actsasconference.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "acts_as_conference 2009 - Confreaks"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "This annual two day event is dedicated to Ruby on Rails and the happy developers that use it (or wish to use it) in their daily lives."
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://aac2009.confreaks.com/"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://aac2009.confreaks.com/images/aac09logo.png"
  end
 
  it 'should extract the description' do
    @podcast.summary.strip.should =~ /^acts_as_conference is an annual two day event/
  end

  it 'should extract the keywords' do
    @podcast.keywords.should == ["ruby", "rails", "confreaks", "conference", 
                                 "software", "web", "development", "engineering"]
  end

  it 'should extract the copyright' do
    @podcast.copyright.should == nil
  end

  it 'should extract the language' do
    @podcast.language.should == "en-us"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == "Confreaks custom podcast generator 1.0"
  end

  it 'should have episodes' do
    @podcast.episodes.size.should == 20
  end

  it 'should have an episode with a title that has decoded html entities' do
    @podcast.episodes[1].title.should == "Live Video Q&A"
  end

  it 'should have an episode with no subtitle' do
    @podcast.episodes[1].subtitle.should == nil
  end
  
  it 'should have an episode with a summary' do
    @podcast.episodes[1].summary.should =~ /<img src=\"http:\/\/feeds2.feedburner.com\/~r\/AAC2009-Confreaks\/~4\/tTNz8NyuSrE\" height=\"1\" width=\"1\"\/>/
  end

  it 'should have an episode with an enclosure with a URL' do
    @podcast.episodes[1].enclosure.url.should == "http://aac2009.confreaks.com/videos/06-feb-2009-10-00-live-video-qa-david-heinemeier-hansson-large.mp4"
  end

  it 'should have an episode with no size' do
    @podcast.episodes[1].enclosure.size.should == 564145577
  end
  
  it 'should have an episode with no duration' do
    @podcast.episodes[1].duration.should == 0
  end

  it 'should have an episode with MRSS' do
    @podcast.episodes[1].media_contents.size.should be(1)
    @podcast.episodes[1].media_contents[0].class.should be(RPodcast::MediaContent)
  end
  
  it 'should have an episode with MRSS with a url' do
    @podcast.episodes[1].media_contents[0].url.should == "http://aac2009.confreaks.com/videos/06-feb-2009-10-00-live-video-qa-david-heinemeier-hansson-large.mp4"
  end

  it 'should have an episode with MRSS with a duration' do
    @podcast.episodes[1].media_contents[0].duration.should == nil
  end

  it 'should have an episode with MRSS with a size' do
    @podcast.episodes[1].media_contents[0].size.should == 564145577
  end

  it 'should have an episode with MRSS with a format' do
    @podcast.episodes[1].media_contents[0].format.should == 'mp4'
  end

  it 'should have an episode with MRSS with a bitrate' do
    @podcast.episodes[1].media_contents[0].bitrate.should == 0
  end
end



describe RPodcast::Feed, "All CNET HD Video Podcasts" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'cnet.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "All CNET HD Video Podcasts"
  end

  it 'should extract the subtitle' do
    @podcast.subtitle.should == "Get your fix of all HD video podcast feeds currently offered through podcast.cnet.com in one place."
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://cnettv.cnet.com/"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://www.cnet.com/i/pod/images/allCNETvideo_600x600.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^Get your fix of all HD video podcast feeds/
  end

  it 'should extract the keywords' do
    @podcast.keywords.should == ["Apple", "Byte", "The", "Buzz", "Report", "Car", 
      "Tech", "Video", "CNET", "Live", "CNET", "News", "CNET", "s", "Top", "5", 
      "Crave", "Loaded", "Mailbag", "Prizefight", "Product", "Spotlight", "Daily",
      "Debrief", "Quick", "Tips"]
  end

  it 'should extract the copyright' do
    @podcast.copyright.should == "2008 CNET.com"
  end

  it 'should extract the language' do
    @podcast.language.should == "en-us"
  end
  
  it 'should extract the generator' do
    @podcast.generator.should == nil
  end

  it 'should have episodes' do
    @podcast.episodes.size.should == 2
  end

  it 'should have an episode with a title that has CDATA stripped out' do
    @podcast.episodes[1].title.should == "Crazy-mail special"
  end

  it 'should have an episode with a subtitle that has CDATA stripped out' do
    @podcast.episodes[1].subtitle.should == "This week on Mailbag, we’re throwing out the podcast feed questions and helpful advice, and just reading the crazy mail. It’s epic."
  end

  it 'should have an episode with a summary' do
    @podcast.episodes[1].summary.should =~ /This week on Mailbag, we’re throwing out the podcast feed quest/
  end

  it 'should have an episode with an enclosure with a URL' do
    @podcast.episodes[1].enclosure.url.should == "http://feedproxy.google.com/~r/cnet/allhdpodcast/~5/RCxI1oZpPDY/mailbag_hd_2009-05-19-174242.m4v"
  end

  it 'should have an episode with a length of 0' do
    @podcast.episodes[1].enclosure.size.should == 0
  end
  
  it 'should have an episode with a duration' do
    @podcast.episodes[1].duration.should == 234
  end
end