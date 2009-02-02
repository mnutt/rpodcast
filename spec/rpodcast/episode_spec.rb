require File.dirname(__FILE__) + '/../spec_helper'

describe RPodcast::Episode do
  before do
    @content = File.open(File.join(ROOT, 'spec', 'data', 'example.xml')).read
    @feed = RPodcast::Feed.new(@content)
    @episode = @feed.episodes.first
  end

  it 'should have raw xml' do
    @episode.raw_xml.should =~ /^<item/
  end
end
