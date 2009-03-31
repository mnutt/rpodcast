require File.dirname(__FILE__) + '/../spec_helper'

describe RPodcast::Feed, "instantiating a new feed" do

  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'example.xml')).read
    @podcast = RPodcast::Feed.new(@content)
    @podcast.parse
  end

  it 'should extract the title' do
    @podcast.title.should == "All About Everything"
  end

  it 'should extract the site link' do
    @podcast.link.should == "http://www.example.com/podcasts/everything/index.html"
  end

  it 'should extract the logo link' do
    @podcast.image.should == "http://summitviewcc.com/picts/PodcastLogo.png"
  end
 
  it 'should extract the description' do
    @podcast.summary.should =~ /^All About Everything is a show about everything/
  end

  it 'should extract the owner email' do
    @podcast.owner_email.should == "john.doe@example.com"
  end

  it 'should extract the owner name' do
    @podcast.owner_name.should == "John Doe"
  end

  it 'should extract the language' do
    @podcast.language.should == "en-us"
  end
end
