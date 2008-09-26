require File.dirname(__FILE__) + '/../spec_helper'

describe RPodcast::Feed, "1upshow" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', '1upshow.xml')).read
    @podcast = RPodcast::Feed.new(@content)
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
end
