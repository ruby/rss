# frozen_string_literal: false

require "cgi"

require_relative "rss-testcase"

require "rss/2.0"
require "rss/media"

module RSS
  module MediaCommonElementsTests
    def test_rating
      assert_media_rating(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_title
      assert_media_title(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_description
      assert_media_description(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_keywords
      assert_media_keywords(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_thumbnail
      assert_media_thumbnail(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_hash
      assert_media_hash(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_player
      assert_media_player(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_credit
      assert_media_credit(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_copyright
      assert_media_copyright(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_text
      assert_media_text(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_restriction
      assert_media_restriction(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_community
      assert_media_community(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_comment
      assert_media_comment(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_embed
      assert_media_embed(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_responses
      assert_media_responses(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_backLinks
      assert_media_backLinks(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_status
      assert_media_status(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_price
      assert_media_price(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_license
      assert_media_license(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_subTitle
      assert_media_subTitle(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_peerLink
      assert_media_peerLink(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_location
      assert_media_location(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_rights
      assert_media_rights(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_scenes
      assert_media_scenes(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    private
    def media_rss20_parse(content, &maker)
      xmlns = {"media" => "http://search.yahoo.com/mrss/"}
      rss20_xml = maker.call(content, xmlns)
      ::RSS::Parser.parse(rss20_xml)
    end

    def assert_media_rating(readers, &rss20_maker)
      content = "adult"
      attributes = {
        scheme: "urn:simple",
      }
      rss20 = media_rss20_parse(tag("media:rating", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_rating = target.media_rating
      assert_equal(attributes.merge(content: content),
                   {
                     scheme: media_rating.scheme,
                     content: media_rating.content,
                   })
    end

    def assert_media_title(readers, &rss20_maker)
      content = "The Judy's -- The Moo Song"
      attributes = {
        type: "plain",
      }
      rss20 = media_rss20_parse(tag("media:title", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_title = target.media_title
      assert_equal(attributes.merge(content: content),
                   {
                     type: media_title.type,
                     content: media_title.content,
                   })
    end

    def assert_media_description(readers, &rss20_maker)
      content =
        "This was some really bizarre band I listened to as a young lad."
      attributes = {
        type: "plain",
      }
      rss20 = media_rss20_parse(tag("media:description", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_description = target.media_description
      assert_equal(attributes.merge(content: content),
                   {
                     type: media_description.type,
                     content: media_description.content,
                   })
    end

    def assert_media_keywords(readers, &rss20_maker)
      keywords = ["kitty", "cat", "big dog", "yarn", "fluffy"]
      rss20 = media_rss20_parse(tag("media:keywords", keywords.join(", ")),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(keywords, target.media_keywords)
    end

    def assert_media_thumbnail(readers, &rss20_maker)
      thumbnails = [
        {
          url: "http://www.foo.com/keyframe.jpg",
          height: 50,
          width: 75,
          time: "12:05:01.123",
        },
      ]
      thumbnail_tags = thumbnails.collect do |thumbnail|
        tag("media:thumbnail", nil, thumbnail)
      end
      rss20 = media_rss20_parse(thumbnail_tags.join(""), &rss20_maker)
      target = chain_reader(rss20, readers)
      media_thumbnails = target.media_thumbnails.collect do |thumbnail|
        {
          url: thumbnail.url,
          height: thumbnail.height,
          width: thumbnail.width,
          time: thumbnail.time,
        }
      end
      assert_equal(thumbnails, media_thumbnails)
    end

    def assert_media_category(readers, &rss20_maker)
      content = "music/artist/album/song"
      attributes = {
        scheme: "http://search.yahoo.com/mrss/category_schema",
      }
      rss20 = media_rss20_parse(tag("media:category", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   {
                     scheme: target.media_category.scheme,
                     content: target.media_category.content,
                   })
    end

    def assert_media_hash(readers, &rss20_maker)
      hashes = [
        {
          algo: "md5",
          content: "dfdec888b72151965a34b4b59031290a",
        },
        {
          algo: "sha-1",
          content: "da39a3ee5e6b4b0d3255bfef95601890afd80709",
        },
      ]
      hash_tags = hashes.collect do |hash|
        tag("media:hash",
            hash[:content],
            hash.reject {|k, v| k == :content})
      end
      rss20 = media_rss20_parse(hash_tags.join(""), &rss20_maker)
      target = chain_reader(rss20, readers)
      media_hashes = target.media_hashes.collect do |hash|
        {
          algo: hash.algo,
          content: hash.content,
        }
      end
      assert_equal(hashes, media_hashes)
    end

    def assert_media_player(readers, &rss20_maker)
      attributes = {
        url: "http://www.foo.com/player?id=1111",
        height: 200,
        width: 400,
      }
      rss20 = media_rss20_parse(tag("media:player", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(attributes,
                   {
                     url: target.media_player.url,
                     height: target.media_player.height,
                     width: target.media_player.width,
                   })
    end

    def assert_media_credit(readers, &rss20_maker)
      credits = [
        {
          role: "producer",
          scheme: "urn:ebu",
          content: "entity name",
        },
        {
          role: "owner",
          scheme: "urn:yvs",
          content: "copyright holder of the entity",
        },
      ]
      credit_tags = credits.collect do |credit|
        tag("media:credit",
            credit[:content],
            credit.reject {|k, v| k == :content})
      end
      rss20 = media_rss20_parse(credit_tags.join(""),  &rss20_maker)
      target = chain_reader(rss20, readers)
      media_credits = target.media_credits.collect do |credit|
        {
          role: credit.role,
          scheme: credit.scheme,
          content: credit.content,
        }
      end
      assert_equal(credits, media_credits)
    end

    def assert_media_copyright(readers, &rss20_maker)
      content = "2005 FooBar Media"
      attributes = {
        url: "http://blah.com/additional-info.htmh",
      }
      rss20 = media_rss20_parse(tag("media:copyright", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(attributes.merge(content: content),
                   {
                     url: target.media_copyright.url,
                     content: target.media_copyright.content,
                   })
    end

    def assert_media_text(readers, &rss20_maker)
      texts = [
        {
          type: "plain",
          lang: "en",
          start: "00:00:03.000",
          end: "00:00:10.000",
          content: "Oh, say, can you see",
        },
        {
          type: "plain",
          lang: "en",
          start: "00:00:10.000",
          end: "00:00:17.000",
          content: "By the dawn's early light",
        },
      ]
      text_tags = texts.collect do |text|
        tag("media:text",
            text[:content],
            text.reject {|k, v| k == :content})
      end
      rss20 = media_rss20_parse(text_tags.join(""), &rss20_maker)
      target = chain_reader(rss20, readers)
      media_texts = target.media_texts.collect do |text|
        {
          type: text.type,
          lang: text.lang,
          start: text.start,
          end: text.end,
          content: text.content,
        }
      end
      assert_equal(texts, media_texts)
    end

    def assert_media_restriction(readers, &rss20_maker)
      restrictions = [
        {
          relationship: "allow",
          type: "country",
          content: "au us",
        },
        {
          relationship: "deny",
          type: "sharing",
          content: "",
        },
      ]
      restriction_tags = restrictions.collect do |restriction|
        tag("media:restriction",
            restriction[:content],
            restriction.reject {|k, v| k == :content})
      end
      rss20 = media_rss20_parse(restriction_tags.join(""), &rss20_maker)
      target = chain_reader(rss20, readers)
      media_restrictions = target.media_restrictions.collect do |restriction|
        {
          relationship: restriction.relationship,
          type: restriction.type,
          content: restriction.content,
        }
      end
      assert_equal(restrictions, media_restrictions)
    end

    def assert_media_community(readers, &rss20_maker)
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
      community_tag = tag("media:community",
                          tag("media:starRating", nil, community[:starRating]) +
                          tag("media:statistics", nil, community[:statistics]) +
                          tag("media:tags", community_tags.join(", ")))
      rss20 = media_rss20_parse(community_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      media_community = target.media_community
      assert_equal(community,
                   {
                     starRating: {
                       average: media_community.media_starRating.average,
                       count: media_community.media_starRating.count,
                       min: media_community.media_starRating.min,
                       max: media_community.media_starRating.max,
                     },
                     statistics: {
                       views: media_community.media_statistics.views,
                       favorites: media_community.media_statistics.favorites,
                     },
                     tags: media_community.media_tags,
                   })
    end

    def assert_media_comment(readers, &rss20_maker)
      comments = [
        "comment1",
        "comment2",
        "comment3",
      ]
      comment_tags = comments.collect do |comment|
        tag("media:comment", comment)
      end
      comments_tag = tag("media:comments", comment_tags.join(""))
      rss20 = media_rss20_parse(comments_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(comments, target.media_comments.to_a)
    end

    def assert_media_embed(readers, &rss20_maker)
      embed = {
        url: "http://d.yimg.com/static.video.yahoo.com/yep/YV_YEP.swf?ver=2.2.2",
        width: 512,
        height: 323,
        params: [
          {
            name: "type",
            content: "application/x-shockwave-flash",
          },
          {
            name: "width",
            content: "512",
          },
          {
            name: "height",
            content: "323",
          },
          {
            name: "allowFullScreen",
            content: "true",
          },
          {
            name: "flashVars",
            content: "id=7809705&vid=2666306&lang=en-us&intl=us&thumbUrl=http://us.i1.yimg.com/us.yimg.com/i/us/sch/cn/video06/2666306_rndf1e4205b_19.jpg",
          },
        ],
      }
      embed_param_tags = embed[:params].collect do |param|
        tag("media:param",
            param[:content],
            param.reject {|k, v| k == :params})
      end
      embed_tag = tag("media:embed",
                      embed_param_tags.join(""),
                      embed.reject {|k, v| k == :params})
      rss20 = media_rss20_parse(embed_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      media_embed = target.media_embed
      media_embed_params = media_embed.media_params.collect do |media_param|
        {
          name: media_param.name,
          content: media_param.content,
        }
      end
      assert_equal(embed,
                   {
                     url: media_embed.url,
                     width: media_embed.width,
                     height: media_embed.height,
                     params: media_embed_params,
                   })
    end

    def assert_media_responses(readers, &rss20_maker)
      responses = [
        "response1",
        "response2",
        "response3",
      ]
      response_tags = responses.collect do |response|
        tag("media:response", response)
      end
      responses_tag = tag("media:responses", response_tags.join(""))
      rss20 = media_rss20_parse(responses_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(responses, target.media_responses.to_a)
    end

    def assert_media_backLinks(readers, &rss20_maker)
      backLinks = [
        "http://www.backlink1.com",
        "http://www.backlink2.com",
        "http://www.backlink3.com",
      ]
      backLink_tags = backLinks.collect do |backLink|
        tag("media:backLink", backLink)
      end
      backLinks_tag = tag("media:backLinks", backLink_tags.join(""))
      rss20 = media_rss20_parse(backLinks_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      assert_equal(backLinks, target.media_backLinks.to_a)
    end

    def assert_media_status(readers, &rss20_maker)
      attributes = {
        state: "blocked",
        reason: "http://www.reasonforblocking.com",
      }
      rss20 = media_rss20_parse(tag("media:status", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_status = target.media_status
      assert_equal(attributes,
                   {
                     state: media_status.state,
                     reason: media_status.reason,
                   })
    end

    def assert_media_price(readers, &rss20_maker)
      attributes = {
        type: "package",
        info: "http://www.dummy.jp/package_info.html",
        price: 19.99,
        currency: "EUR",
      }
      rss20 = media_rss20_parse(tag("media:price", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_price = target.media_price
      assert_equal(attributes,
                   {
                     type: media_price.type,
                     info: media_price.info,
                     price: media_price.price,
                     currency: media_price.currency,
                   })
    end

    def assert_media_license(readers, &rss20_maker)
      content = "Creative Commons Attribution 3.0 United States License"
      attributes = {
        type: "text/html",
        href: "http://creativecommons.org/licenses/by/3.0/us/",
      }
      rss20 = media_rss20_parse(tag("media:license", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_license = target.media_license
      assert_equal(attributes.merge(content: content),
                   {
                     type: media_license.type,
                     href: media_license.href,
                     content: content,
                   })
    end

    def assert_media_subTitle(readers, &rss20_maker)
      attributes = {
        type: "application/smil",
        lang: "en-us",
        href: "http://www.example.org/subtitle.smil",
      }
      rss20 = media_rss20_parse(tag("media:subTitle", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_subTitle = target.media_subTitle
      assert_equal(attributes,
                   {
                     type: media_subTitle.type,
                     lang: media_subTitle.lang,
                     href: media_subTitle.href,
                   })
    end

    def assert_media_peerLink(readers, &rss20_maker)
      attributes = {
        type: "application/x-bittorrent",
        href: "http://www.example.org/sampleFile.torrent",
      }
      rss20 = media_rss20_parse(tag("media:peerLink", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_peerLink = target.media_peerLink
      assert_equal(attributes,
                   {
                     type: media_peerLink.type,
                     href: media_peerLink.href,
                   })
    end

    def assert_media_location(readers, &rss20_maker)
      content = nil # TODO geoRSS
      attributes = {
        description: "My house",
        start: "00:01",
        end: "01:00",
      }
      rss20 = media_rss20_parse(tag("media:location", content, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_location = target.media_location
      assert_equal(attributes,
                   {
                     description: media_location.description,
                     start: media_location.start,
                     end: media_location.end,
                   })
    end

    def assert_media_rights(readers, &rss20_maker)
      attributes = {
        status: "userCreated",
      }
      rss20 = media_rss20_parse(tag("media:rights", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_rights = target.media_rights
      assert_equal(attributes,
                   {
                     status: media_rights.status,
                   })
    end

    def assert_media_scenes(readers, &rss20_maker)
      scenes = [
        {
          sceneTitle: "sceneTitle1",
          sceneDescription: "sceneDesc1",
          sceneStartTime: "00:15",
          sceneEndTime: "00:45",
        },
        {
          sceneTitle: "sceneTitle2",
          sceneDescription: "sceneDesc2",
          sceneStartTime: "00:57",
          sceneEndTime: "01:45",
        },
      ]
      scene_tags = scenes.collect do |scene|
        scene_contents = scene.collect do |key, value|
          tag(key, value)
        end
        tag("media:scene", scene_contents.join(""))
      end
      scenes_tag = tag("media:scenes", scene_tags.join(""))
      rss20 = media_rss20_parse(scenes_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      media_scenes = target.media_scenes.to_a.collect do |scene|
        {
          sceneTitle: scene.title,
          sceneDescription: scene.description,
          sceneStartTime: scene.startTime,
          sceneEndTime: scene.endTime,
        }
      end
      assert_equal(scenes, media_scenes)
    end

    def assert_media_content(readers, &rss20_maker)
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
      rss20 = media_rss20_parse(tag("media:content", nil, attributes),
                                &rss20_maker)
      target = chain_reader(rss20, readers)
      media_content = target.media_content
      assert_equal(attributes,
                   {
                     url: media_content.url,
                     fileSize: media_content.fileSize,
                     type: media_content.type,
                     medium: media_content.medium,
                     isDefault: media_content.Default?,
                     expression: media_content.expression,
                     bitrate: media_content.bitrate,
                     framerate: media_content.framerate,
                     samplingrate: media_content.samplingrate,
                     channels: media_content.channels,
                     duration: media_content.duration,
                     height: media_content.height,
                     width: media_content.width,
                     lang: media_content.lang,
                   })
    end

    def assert_media_group(readers, &rss20_maker)
      contents = [
        {
          url: "http://example.com/movie.mov",
        },
        {
          url: "http://example.com/movie.mp4",
        },
      ]
      content_tags = contents.collect do |content|
        content_contents = content.collect do |key, value|
          tag(key, value)
        end
        tag("media:content", content_contents.join(""))
      end
      group_tag = tag("media:group", content_tags.join(""))
      rss20 = media_rss20_parse(group_tag, &rss20_maker)
      target = chain_reader(rss20, readers)
      media_contents = target.media_group.media_contents.collect do |content|
        {
          url: content.url,
        }
      end
      assert_equal(contents, media_contents)
    end
  end

  class TestMediaChannel < TestCase
    include MediaCommonElementsTests

    private
    def readers
      ["channel"]
    end

    def make_target(content, xmlns)
      make_rss20(make_channel20(content),
                 xmlns)
    end
  end

  class TestMediaItem < TestCase
    include MediaCommonElementsTests

    def test_content
      assert_media_content(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    def test_group
      assert_media_group(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    private
    def readers
      ["items", "last"]
    end

    def make_target(content, xmlns)
      make_rss20(make_channel20(make_item20(content)),
                 xmlns)
    end
  end

  class TestMediaContent < TestCase
    include MediaCommonElementsTests

    private
    def readers
      ["items", "last", "media_content"]
    end

    def make_target(content, xmlns)
      make_rss20(make_channel20(make_item20(tag("media:content", content))),
                 xmlns)
    end
  end

  class TestMediaGroup < TestCase
    include MediaCommonElementsTests

    def test_content
      assert_media_content(readers) do |content, xmlns|
        make_target(content, xmlns)
      end
    end

    private
    def readers
      ["items", "last", "media_group"]
    end

    def make_target(content, xmlns)
      make_rss20(make_channel20(make_item20(tag("media:group", content))),
                 xmlns)
    end
  end
end
