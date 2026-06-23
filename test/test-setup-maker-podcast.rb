# frozen_string_literal: false
require_relative "rss-testcase"

require "rss/maker"

module RSS
  class TestSetupMakerPodcast < TestCase
    def test_setup_maker_simple
      transcripts = [
        { :url => "https://example.com/episode1/transcript.html", :type => "text/html"}
      ]
      locked = true
      locked_owner = "email@example.com"
      fundings = [
        { :url => "https://www.example.com/donations", :text => "Support the show!"}
      ]
      chapters = [
        { :url => "https://example.com/episode1/chapters.json", :type => "application/json+chapter"}
      ]
      soundbites = [
        { :startTime => "1234.5" :duration => "42.25", :text => "Why the Podcast Namespace Matters"}
      ]
      persons = [
        { :href => "https://example.com/johnsmith/blog", :img => "http://example.com/images/johnsmith.jpg", :name => "John Smith" }
      ]    
      # TODO: location, season, episode – https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#location


      feed = RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        channel = maker.channel
        channel.locked = locked
        channel.locked.owner = locked_owner
        fundings.each do |funding|
          new_funding = channel.podcast_funding.new_funding
          new_funding.text = funding.text
          new_funding.url = funding.url
        end
        #TODO channel.podcast_persons
 
        item = maker.items.last
        item.podcast_chapters = chapters
        item.podcast_soundbite = soundbites
        item.podcast_person = persons
        # TODO
      end
      assert_not_nil(feed)

      new_feed = RSS::Maker.make("rss2.0") do |maker|
        feed.setup_maker(maker)
      end
      assert_not_nil(new_feed)

      channel = new_feed.channel
      item = new_feed.items.last

      assert_equal(locked, channel.locked)
      assert_equal(locked_owner, item.locked.owner)

      new_fundings = new_feed.podcast_fundings.collect do |f|
        {
          :url => f.url,
          :text => f.content
        }
      end
      assert_equal(fundings, new_fundings)

      #assert_equal(categories, collect_itunes_categories(channel.itunes_categories))

      #assert_equal(owner,
      #             {
      #               :name => channel.itunes_owner.itunes_name,
      #               :email => channel.itunes_owner.itunes_email
      #             })
    end
  end
end
