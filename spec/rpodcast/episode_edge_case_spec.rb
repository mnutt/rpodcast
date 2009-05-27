require File.dirname(__FILE__) + '/../spec_helper'

describe RPodcast::Episode, "All CNET HD Video Podcasts" do
  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'cnet.xml')).read
    @feed = RPodcast::Feed.new(@content)
    @feed.parse
    @episode = @feed.episodes.first
  end

  it 'should have raw xml' do
    @episode.raw_xml.should =~ /^<item/
  end

  it 'should extract the title with CDATA stripped out' do
    @episode.title.should == "Nintendo DSi vs. PSP-3000"
  end
 
  it 'should extract the description' do
    @episode.summary.should =~ /^It's a rematch for portable gaming supremacy! Nintendo and Sony have both made updates, but will Nintendo's brand-new DSi be able to take down the PSP once again?/
  end

  it 'should extract the duration' do
    @episode.duration.should == 19920
  end
  
  it 'should extract the published_at value' do
    @episode.published_at.should == Time.parse("Tue, 19 May 2009 04:01:34 PDT")
  end
end

describe RPodcast::Feed, "macbreak" do
  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'feeds', 'macbreak.xml')).read
    @feed = RPodcast::Feed.new(@content)
    @feed.parse
    @episode = @feed.episodes[103]
  end

  it 'should have raw xml' do
    @episode.raw_xml.should =~ /^<item/
  end

  it 'should extract the title with CDATA stripped out' do
    @episode.title.should == "MacBreak 62: Summarize"
  end
 
  it 'should extract the description' do
    @episode.summary.should =~ /^Kenji Kato shows us how to use a little-known summarization tool buried in the Services menu./
  end

  it 'should extract the duration' do
    @episode.duration.should == 325
  end
  
  it 'should extract the published_at value' do
    @episode.published_at.should == Time.parse("Mon, 05 Feb 2007 00:00:00 GMT")
  end
  
end