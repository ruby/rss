# frozen_string_literal: false
require_relative "rss-testcase"

require "rss/maker"
require "rss/podcast"


# https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md

module RSS
  class TestMakerPodcast < TestCase
    def test_transcript
      assert_maker_podcast_transcript(%w(items last))
    end

    def test_locked
      assert_maker_podcast_locked(%w(channel))
    end

=begin
    def test_funding
      assert_maker_podcast_funding(%w(channel))
    end

    def test_chapters
      assert_maker_podcast_chapters(%w(items last))
    end

    def test_soundbite
      assert_maker_podcast_soundbite(%w(items last))
    end

    def test_person
      assert_maker_podcast_person(%w(channel))
      assert_maker_podcast_person(%w(items last))
    end

    def test_location
      assert_maker_podcast_location(%w(channel))
      assert_maker_podcast_location(%w(items last))
    end

    def test_season
      assert_maker_podcast_season(%w(items last))
    end

    def test_episode
      assert_maker_podcast_episode(%w(items last))
    end
=end 
    private

    def _assert_maker_podcast_transcript(url, type, language, rel, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        transcript = ::RSS::PodcastTranscript.new(url, type, language, rel)
        target.transcript << transcript
        assert_equal(url, target.transcript.first.url)
      end
      target = chain_reader(rss20, feed_readers)
      assert_equal(value, target.podcast_locked)
      assert_equal(boolean_value, target.podcast_locked?)
      # TODO: test owner attribute 
    end


    def assert_maker_podcast_transcript(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_transcript("https://example.com/episode1/transcript.html", "text/html", nil, nil, maker_readers, feed_readers)
        _assert_maker_podcast_transcript("https://example.com/episode1/transcript.srt", "text/srt", nil,"captions", maker_readers, feed_readers)
        _assert_maker_podcast_transcript("https://example.com/episode1/transcript.json", "application/json", "es", "captions", maker_readers, feed_readers)
        _assert_maker_podcast_transcript("https://example.com/episode1/transcript.vtt", "text/vtt", nil, nil, maker_readers, feed_readers)
      end
    end



    def _assert_maker_podcast_locked(value, boolean_value, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        target.podcast_locked = value
        assert_equal(value, target.podcast_locked)
        assert_equal(boolean_value, target.podcast_locked?)
      end
      target = chain_reader(rss20, feed_readers)
      if [true, false].include?(value)
        value = value ? "yes" : "no"
      end
      assert_equal(value, target.podcast_locked)
      assert_equal(boolean_value, target.podcast_locked?)
      # TODO: test owner attribute 
    end

    def assert_maker_podcast_locked(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_locked("yes", true, maker_readers, feed_readers)
        _assert_maker_podcast_locked("Yes", true, maker_readers, feed_readers)
        _assert_maker_podcast_locked("no", false, maker_readers, feed_readers)
        _assert_maker_podcast_locked("", false, maker_readers, feed_readers)
        _assert_maker_podcast_locked(true, true, maker_readers, feed_readers)
        _assert_maker_podcast_locked(false, false, maker_readers, feed_readers)
        _assert_maker_podcast_locked(nil, false, maker_readers, feed_readers)
      end
    end

    def _assert_maker_podcast_funding(categories, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        categories.each do |funding|
          sub_target = target.podcast_categories
          if funding.is_a?(Array)
            funding.each do |sub_funding|
              sub_target = sub_target.new_funding
              sub_target.text = sub_funding
            end
          else
            sub_target.new_funding.text = funding
          end
        end
      end

      target = chain_reader(rss20, feed_readers)
      actual_categories = target.podcast_categories.collect do |funding|
        cat = funding.text
        if funding.podcast_categories.empty?
          cat
        else
          [cat, *funding.podcast_categories.collect {|c| c.text}]
        end
      end
      assert_equal(categories, actual_categories)
    end

    def assert_maker_podcast_funding(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_funding(["Audio Blogs"], maker_readers, feed_readers)
        _assert_maker_podcast_funding([["Arts & Entertainment", "Games"]], maker_readers, feed_readers)
        _assert_maker_podcast_funding([["Arts & Entertainment", "Games"],  ["Technology", "Computers"],  "Audio Blogs"], maker_readers, feed_readers)
      end
    end

    def assert_maker_podcast_image(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        url = "http://example.com/podcasts/everything/AllAboutEverything.jpg"

        rss20 = ::RSS::Maker.make("rss2.0") do |maker|
          setup_dummy_channel(maker)
          setup_dummy_item(maker)

          target = chain_reader(maker, maker_readers)
          target.podcast_image = url
        end

        target = chain_reader(rss20, feed_readers)
        assert_not_nil(target.podcast_image)
        assert_equal(url, target.podcast_image.href)
      end
    end

    def _assert_maker_podcast_duration(hour, minute, second, value, maker_readers, feed_readers)
      _assert_maker_podcast_duration_by_value(hour, minute, second, value,      maker_readers, feed_readers)
      _assert_maker_podcast_duration_by_hour_minute_second(hour, minute, second,                     value,                   maker_readers,                     feed_readers)
    end


    def _assert_maker_podcast_location(location, value, maker_readers, feed_readers)
      _assert_maker_podcast_location_by_value(location, value, maker_readers, feed_readers)
      _assert_maker_podcast_location_by_location(location, maker_readers, feed_readers)
    end

    def _assert_maker_podcast_location_by(location, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        yield(target)
      end
      assert_nothing_raised do
        rss20 = ::RSS::Parser.parse(rss20.to_s)
      end
      target = chain_reader(rss20, feed_readers)
      assert_equal(location, target.podcast_location)
    end

    def _assert_maker_podcast_location_by_value(location, value, maker_readers, feed_readers)
      _assert_maker_podcast_location_by(location, maker_readers, feed_readers) do |target|
        target.podcast_location = value
      end
    end

    def _assert_maker_podcast_location_by_location(location, maker_readers, feed_readers)
      _assert_maker_podcast_location_by(location, maker_readers, feed_readers) do |target|
        target.podcast_location = location
      end
    end

    def assert_maker_podcast_location(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_location(["salt"], "salt", maker_readers, feed_readers)
        _assert_maker_podcast_location(["salt"], " salt ", maker_readers, feed_readers)
        _assert_maker_podcast_location(["salt", "pepper", "shaker", "exciting"], "salt, pepper, shaker, exciting", maker_readers, feed_readers)
        _assert_maker_podcast_location(["metric", "socket", "wrenches",  "toolsalt"], "metric, socket, wrenches, toolsalt", maker_readers, feed_readers)
        _assert_maker_podcast_location(["olitics", "red", "blue", "state"], "olitics, red, blue, state", maker_readers, feed_readers)
      end
    end

    def assert_maker_podcast_type(maker_readers, feed_readers=nil)
      feed_readers ||= maker_readers
      type = "serial"

      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        target.podcast_type = type
      end
      target = chain_reader(rss20, feed_readers)
      assert_equal(type, target.podcast_type)
    end

    def _assert_maker_podcast_owner(name, email, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        owner = target.podcast_owner
        owner.podcast_name = name
        owner.podcast_email = email
      end
      owner = chain_reader(rss20, feed_readers).podcast_owner
      if name.nil? and email.nil?
        assert_nil(owner)
      else
        assert_not_nil(owner)
        assert_equal(name, owner.podcast_name)
        assert_equal(email, owner.podcast_email)
      end
    end

    def assert_maker_podcast_owner(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_owner("John Doe", "john.doe@example.com", maker_readers, feed_readers)

        not_set_name = (["maker"] + maker_readers + ["podcast_owner"]).join(".")
        assert_not_set_error(not_set_name, ["podcast_name"]) do
          _assert_maker_podcast_owner(nil, "john.doe@example.com", maker_readers, feed_readers)
        end
        assert_not_set_error(not_set_name, ["podcast_email"]) do
          _assert_maker_podcast_owner("John Doe", nil, maker_readers, feed_readers)
        end

        _assert_maker_podcast_owner(nil, nil, maker_readers, feed_readers)
      end
    end

    def _assert_maker_podcast_subtitle(subtitle, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        target.podcast_subtitle = subtitle
      end

      target = chain_reader(rss20, feed_readers)
      assert_equal(subtitle, target.podcast_subtitle)
    end

    def assert_maker_podcast_subtitle(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_subtitle("A show about everything", maker_readers, feed_readers)
        _assert_maker_podcast_subtitle("A short primer on table spices", maker_readers, feed_readers)
        _assert_maker_podcast_subtitle("Comparing socket wrenches is fun!", maker_readers, feed_readers)
        _assert_maker_podcast_subtitle("Red + Blue != Purple", maker_readers, feed_readers)
      end
    end

    def _assert_maker_podcast_episode(episode, maker_readers, feed_readers)
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, maker_readers)
        target.podcast_episode = episode
      end

      target = chain_reader(rss20, feed_readers)
      assert_equal(episode, target.podcast_episode)
    end

    def assert_maker_podcast_episode(maker_readers, feed_readers=nil)
      _wrap_assertion do
        feed_readers ||= maker_readers
        _assert_maker_podcast_episode("All About Everything is a show about everything. Each week we dive into any subject known to man and talk about it as much as we can. Look for our Podcast in the iTunes Music Store", maker_readers, feed_readers)
        _assert_maker_podcast_episode("This week we talk about salt and pepper shakers, comparing and contrasting pour rates, construction materials, and overall aesthetics. Come and join the party!", maker_readers, feed_readers)
        _assert_maker_podcast_episode("This week we talk about metric vs. old english socket wrenches. Which one is better? Do you really need both? Get all of your answers here.", maker_readers, feed_readers)
        _assert_maker_podcast_episode("This week we talk about surviving in a Red state if you're a Blue person. Or vice versa.", maker_readers, feed_readers)
      end
    end
  end
end
