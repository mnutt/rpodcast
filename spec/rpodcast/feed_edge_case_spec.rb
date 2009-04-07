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

  it 'should extract the site link' do
    @podcast.link.should == "http://the1upshow.1up.com/"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://www.1up.com/flat/Podcasts/1upvideo300x300.jpg"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^1UP editors report on the videogame industry/
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

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 2679
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.to_i.should == 1311
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

  describe "first episode" do

    it 'should have a title' do
      @podcast.episodes.first.title.should =~ /Diggnation - Prager/
    end
    
    it 'should have a summary' do
      @podcast.episodes.first.summary.strip.should == "\nCreative Business Card Designs, Early Dark Knight Concept Art Shows a Much Creepier Joker, This Guy Actually Bought the I Am Rich App for $999.99, Ikea to Start Selling Solar Panels, Slow Motion Lightning Video is Mindblowing. <span style=\"color: #FF0000\">LIVE SHOW ON TUESDAY AUG 26TH!!!</span>".strip
    end

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 2679
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.to_i.should == 1311
    end

    it 'should have a hash' do
      @podcast.episodes.first.hashes['md5'].should == 'this_is_a_fake_md5_hash'
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

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 308
    end

    it 'should not have a bitrate' do # they have incorrect sizes
      @podcast.episodes.first.bitrate.to_i.should == 0
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

    it 'should have a duration' do
      @podcast.episodes.first.duration.should == 160
    end

    it 'should have a bitrate' do
      @podcast.episodes.first.bitrate.should == 1646.6225
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
    @podcast.episodes[1].duration.should == 91500
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
    @podcast.episodes.size.should == 28
  end

  it 'should have an episode with a title that has decoded html entities' do
    @podcast.episodes[1].title.should == "Unicorn Chaser: Joel Johnson of Boing Boing Gadgets in\n      \"UHHHHHH.\""
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
end
