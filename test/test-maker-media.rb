# frozen_string_literal: false

require_relative "rss-testcase"

require "rss/maker"

module RSS
  module MakerMediaCommonElementsTests
    def test_rating
      assert_maker_media_rating(readers)
    end

    def test_title
      assert_maker_media_title(readers)
    end

    def test_description
      assert_maker_media_description(readers)
    end

    def test_keywords
      assert_maker_media_keywords(readers)
    end

    def test_thumbnail
      assert_maker_media_thumbnail(readers)
    end

    def test_category
      assert_maker_media_category(readers)
    end

    def test_hash
      assert_maker_media_hash(readers)
    end

    def test_player
      assert_maker_media_player(readers)
    end

    def test_credit
      assert_maker_media_credit(readers)
    end

    def test_copyright
      assert_maker_media_copyright(readers)
    end

    def test_text
      assert_maker_media_text(readers)
    end

    def test_restriction
      assert_maker_media_restriction(readers)
    end

    def test_community
      assert_maker_media_community(readers)
    end

    def test_comment
      assert_maker_media_comment(readers) TODO and more elements...
    end

    private
    def make_rss20(readers, attributes={}, content=nil)
      ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, readers)
        target.content = content if content
        attributes.each do |key, value|
          target.__send__("#{key}=", value)
        end
        yield(target) if block_given?
      end
    end

    def extract_attributes(target, attribute_names)
      attributes = {}
      attributes[:content] = target.content if target.respond_to?(:content)
      attribute_names.each do |name|
        attributes[name] = target.__send__(name)
      end
      attributes
    end

    def assert_maker_media_rating(readers)
      readers += ["media_rating"]
      attributes = {
        scheme: "urn:simple",
      }
      content = "adult"
      rss20 = make_rss20(readers, attributes, content)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_title(readers)
      readers += ["media_title"]
      attributes = {
        type: "plain",
      }
      content = "The Judy's -- The Moo Song"
      rss20 = make_rss20(readers, attributes, content)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_description(readers)
      readers += ["media_description"]
      attributes = {
        type: "plain",
      }
      content =
        "This was some really bizarre band I listened to as a young lad."
      rss20 = make_rss20(readers, attributes, content)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_keywords(readers)
      keywords = ["kitty", "cat", "big dog", "yarn", "fluffy"]
      rss20 = make_rss20(readers, media_keywords: keywords)
      target = chain_reader(rss20, readers)
      assert_equal({media_keywords: keywords},
                   extract_attributes(target, [:media_keywords]))
    end

    def assert_maker_media_thumbnail(readers)
      readers += ["media_thumbnails"]
      attributes = {
        url: "http://www.foo.com/keyframe.jpg",
        height: 50,
        width: 75,
        time: "12:05:01.123",
      }
      rss20 = make_rss20(readers + ["new_media_thumbnail"], attributes)
      target = chain_reader(rss20, readers).first
      assert_equal(attributes,
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_category(readers)
      readers += ["media_category"]
      content = "music/artist/album/song"
      attributes = {
        scheme: "http://search.yahoo.com/mrss/category_schema",
      }
      rss20 = make_rss20(readers, attributes, content)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_hash(readers)
      readers += ["media_hashes"]
      attributes = {
        algo: "md5",
      }
      content = "dfdec888b72151965a34b4b59031290a"
      rss20 = make_rss20(readers + ["new_media_hash"], attributes, content)
      target = chain_reader(rss20, readers).first
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_player(readers)
      readers += ["media_player"]
      attributes = {
        url: "http://www.foo.com/player?id=1111",
        height: 200,
        width: 400,
      }
      rss20 = make_rss20(readers, attributes)
      target = chain_reader(rss20, readers)
      assert_equal(attributes,
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_credit(readers)
      readers += ["media_credits"]
      attributes = {
        role: "producer",
        scheme: "urn:ebu",
      }
      content = "entity name"
      rss20 = make_rss20(readers + ["new_media_credit"], attributes, content)
      target = chain_reader(rss20, readers).first
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_copyright(readers)
      readers += ["media_copyright"]
      attributes = {
        url: "http://blah.com/additional-info.htmh",
      }
      content = "2005 FooBar Media"
      rss20 = make_rss20(readers, attributes, content)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_text(readers)
      readers += ["media_texts"]
      attributes = {
        type: "plain",
        lang: "en",
        start: "00:00:03.000",
        end: "00:00:10.000",
      }
      content = "Oh, say, can you see"
      rss20 = make_rss20(readers + ["new_media_text"], attributes, content)
      target = chain_reader(rss20, readers).first
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_restriction(readers)
      readers += ["media_restrictions"]
      attributes = {
        relationship: "allow",
        type: "country",
      }
      content = "au us"
      rss20 = make_rss20(readers + ["new_media_restriction"],
                         attributes,
                         content)
      target = chain_reader(rss20, readers).first
      assert_equal(attributes.merge(content: content),
                   extract_attributes(target, attributes.keys))
    end

    def assert_maker_media_community(readers)
      readers += ["media_community"]
      community = {
        starRating: {
          average: 3.5,
          count: 20,
          min: 1,
          max: 10,
        },
        statistics: {
          views: 5,
          favorites: 15,
        },
        tags: {
          "news" => 5,
          "abc" => 3,
          "reuters" => 1,
        },
      }
      community_tags = community[:tags].collect do |name, weight|
        if weight == 1
          name
        else
          "#{name}:#{weight}"
        end
      end
      rss20 = make_rss20(readers) do |target|
        community.each do |name, attributes|
          case name
          when :tags
            target.media_tags = community_tags.join(", ")
          else
            subtarget = target.__send__("media_#{name}")
            attributes.each do |key, value|
              subtarget.__send__("#{key}=", value)
            end
          end
        end
      end
      target = chain_reader(rss20, readers)
      assert_equal(community,
                   {
                     starRating: {
                       average: target.media_starRating.average,
                       count: target.media_starRating.count,
                       min: target.media_starRating.min,
                       max: target.media_starRating.max,
                     },
                     statistics: {
                       views: target.media_statistics.views,
                       favorites: target.media_statistics.favorites,
                     },
                     tags: target.media_tags,
                   })
    end
  end

  class TestMakerMediaItem < TestCase
    include MakerMediaCommonElementsTests

    def test_content
      assert_maker_media_content(readers)
    end

    private
    def readers
      ["items", "last"]
    end

    def assert_maker_media_content(readers)
      attributes = {
        url: "http://www.foo.com/movie.mov",
        fileSize: 12216320,
        type: "video/quicktime",
        medium: "video",
        isDefault: true,
        expression: "full",
        bitrate: 128,
        framerate: 25,
        samplingrate: 44.1,
        channels: 2,
        duration: 185,
        height: 200,
        width: 300,
        lang: "en",
      }
      rss20 = ::RSS::Maker.make("rss2.0") do |maker|
        setup_dummy_channel(maker)
        setup_dummy_item(maker)

        target = chain_reader(maker, readers)
        target.media_contents.new_media_content do |media_content|
          attributes.each do |key, value|
            media_content.__send__("#{key}=", value)
          end
        end
      end
      target = chain_reader(rss20, readers + ["media_contents", "last"])
      actual = {}
      attributes.each_key do |key|
        actual[key] = target.__send__(key)
      end
      assert_equal(attributes, actual)
    end
  end
end
