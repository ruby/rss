require "rss/2.0"

module RSS
  # The prefix for the Media RSS namespace.
  MEDIA_PREFIX = "media"
  # The URI for the specification of the Media RSS namespace.
  MEDIA_URI = "http://search.yahoo.com/mrss/"

  Rss.install_ns(MEDIA_PREFIX, MEDIA_URI)

  [
    "group",
    "content",
    "rating",
    "title",
    "description",
    "thumbnail",
    "category",
    "hash",
    "player",
    "credit",
    "copyright",
    "text",
    "restriction",
    "community",
    "starRating",
    "statistics",
    "comments",
    "comment",
    "embed",
    "param",
    "responses",
    "response",
    "backLinks",
    "backLink",
    "status",
    "price",
    "license",
    "subTitle",
    "peerLink",
    "location",
    "rights",
    "scenes",
    "scene",
  ].each do |name|
    class_name = Utils.to_class_name(name)
    BaseListener.install_class_name(MEDIA_URI, name, "Media#{class_name}")
  end

  [
    "sceneTitle",
    "sceneDescription",
    "sceneStartTime",
    "sceneEndTime",
  ].each do |name|
    BaseListener.install_get_text_element("", name, name)
  end

  [
    "keywords",
    "tags",
  ].each do |name|
    BaseListener.install_get_text_element(MEDIA_URI,
                                          name,
                                          "#{MEDIA_PREFIX}_#{name}")
  end

  module MediaRatingModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "rating"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaRating < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "rating"

      ATTRIBUTES = [
        ["scheme"],
      ]
      ATTRIBUTES.each do |name, |
        install_get_attribute(name, "", false)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_content
      end

      def setup_maker_attributes(rating)
        rating.scheme = scheme
        rating.content = content
      end
    end
  end

  module MediaTitleModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "title"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaTitle < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "title"

      ATTRIBUTES = [
        ["type", false, :media_type],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_title
      end

      def setup_maker_attributes(title)
        title.type = type
        title.content = content
      end
    end
  end

  module MediaDescriptionModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "description"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaDescription < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "description"

      ATTRIBUTES = [
        ["type", false, :media_type],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_description
      end

      def setup_maker_attributes(description)
        description.type = type
        description.content = content
      end
    end
  end

  module MediaThumbnailModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "thumbnail"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      plural_name = "#{MEDIA_PREFIX}_#{tag_name}s"
      klass.install_have_children_element(tag_name,
                                          MEDIA_URI,
                                          "*",
                                          name,
                                          plural_name)
    end

    class MediaThumbnail < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "thumbnail"

      ATTRIBUTES = [
        ["url", true],
        ["height", false, :integer],
        ["width", false, :integer],
        ["time", false],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_thumbnail
      end

      def setup_maker_attributes(thumbnail)
        thumbnail.url = url
        thumbnail.height = height
        thumbnail.width = width
        thumbnail.time = time
      end
    end
  end

  module MediaCategoryModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "category"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaCategory < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "category"

      ATTRIBUTES = [
        ["scheme"],
      ]
      ATTRIBUTES.each do |name,|
        install_get_attribute(name, "", false)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_category
      end

      def setup_maker_attributes(category)
        category.scheme = scheme
        category.content = content
      end
    end
  end

  module MediaHashModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "hash"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      plural_name = "#{MEDIA_PREFIX}_#{tag_name}es"
      klass.install_have_children_element(tag_name,
                                          MEDIA_URI,
                                          "*",
                                          name,
                                          plural_name)
    end

    class MediaHash < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "hash"

      ATTRIBUTES = [
        ["algo", false, :media_hash_algo],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_hash
      end

      def setup_maker_attributes(hash)
        hash.algo = algo
        hash.content = content
      end
    end
  end

  module MediaPlayerModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "player"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaPlayer < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "player"

      ATTRIBUTES = [
        ["url", true],
        ["height", false, :integer],
        ["width", false, :integer],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_player
      end

      def setup_maker_attributes(player)
        player.url = url
        player.height = height
        player.width = width
      end
    end
  end

  module MediaCreditModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "credit"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      plural_name = "#{MEDIA_PREFIX}_#{tag_name}s"
      klass.install_have_children_element(tag_name,
                                          MEDIA_URI,
                                          "*",
                                          name,
                                          plural_name)
    end

    class MediaCredit < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "credit"

      ATTRIBUTES = [
        ["role", false],
        ["scheme", false, :media_credit_scheme],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_credit
      end

      def setup_maker_attributes(credit)
        credit.role = role
        credit.scheme = scheme
        credit.content = content
      end
    end
  end

  module MediaCopyrightModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "copyright"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaCopyright < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "copyright"

      ATTRIBUTES = [
        ["url"],
      ]
      ATTRIBUTES.each do |name,|
        install_get_attribute(name, "", false)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_copyright
      end

      def setup_maker_attributes(copyright)
        copyright.url = url
        copyright.content = content
      end
    end
  end

  module MediaTextModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "text"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      plural_name = "#{MEDIA_PREFIX}_#{tag_name}s"
      klass.install_have_children_element(tag_name,
                                          MEDIA_URI,
                                          "*",
                                          name,
                                          plural_name)
    end

    class MediaText < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "text"

      ATTRIBUTES = [
        ["type", false, :media_type],
        ["lang", false],
        ["start", false],
        ["end", false],
      ]
      ATTRIBUTES.each do |name, required, type|
        install_get_attribute(name, "", required, type)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_text
      end

      def setup_maker_attributes(text)
        text.type = type
        text.lang = lang
        text.start = start
        text.end = self.end
        text.content = content
      end
    end
  end

  module MediaRestrictionModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "restriction"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      plural_name = "#{MEDIA_PREFIX}_#{tag_name}s"
      klass.install_have_children_element(tag_name,
                                          MEDIA_URI,
                                          "*",
                                          name,
                                          plural_name)
    end

    class MediaRestriction < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "restriction"

      ATTRIBUTES = [
        ["relationship", true],
        ["type", false],
      ]
      ATTRIBUTES.each do |name, required|
        install_get_attribute(name, "", required)
      end

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_restriction
      end

      def setup_maker_attributes(restriction)
        restriction.relationship = relationship
        restriction.type = type
        restriction.content = content
      end
    end
  end

  module MediaCommunityModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "community"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaCommunity < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "community"

      install_have_child_element("starRating",
                                 MEDIA_URI,
                                 "?",
                                 "#{MEDIA_PREFIX}_starRating")
      install_have_child_element("statistics",
                                 MEDIA_URI,
                                 "?",
                                 "#{MEDIA_PREFIX}_statistics")
      install_text_element("tags",
                           MEDIA_URI,
                           "?",
                           "#{MEDIA_PREFIX}_tags",
                           :media_tags)

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_community
      end

      class MediaStarRating < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "starRating"

        ATTRIBUTES = [
          ["average", false, :float],
          ["count", false, :integer],
          ["min", false, :integer],
          ["max", false, :integer],
        ]
        ATTRIBUTES.each do |name, required, type|
          install_get_attribute(name, "", required, type)
        end

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_starRating
        end

        def setup_maker_attributes(starRating)
          starRating.average = average
          starRating.count = count
          starRating.min = min
          starRating.max = max
        end
      end

      class MediaStatistics < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "statistics"

        ATTRIBUTES = [
          ["views", false, :integer],
          ["favorites", false, :integer],
        ]
        ATTRIBUTES.each do |name, required, type|
          install_get_attribute(name, "", required, type)
        end

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_starRating
        end

        def setup_maker_attributes(starRating)
          starRating.views = views
          starRating.favorites = favorites
        end
      end
    end
  end

  module MediaCommentsModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "comments"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaComments < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "comments"

      install_have_children_element("comment",
                                    MEDIA_URI,
                                    "*",
                                    "#{MEDIA_PREFIX}_comment",
                                    "#{MEDIA_PREFIX}_comments")

      def to_a
        media_comments.collect(&:content)
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_comments
      end

      class MediaComment < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "comment"

        content_setup

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_comment
        end

        def setup_maker_attributes(comment)
          comment.content = content
        end
      end
    end
  end

  module MediaEmbedModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "embed"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaEmbed < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "embed"

      install_get_attribute("url", "", true)
      install_get_attribute("height", "", false, :integer)
      install_get_attribute("width", "", false, :integer)

      install_have_children_element("param",
                                    MEDIA_URI,
                                    "*",
                                    "#{MEDIA_PREFIX}_param",
                                    "#{MEDIA_PREFIX}_params")

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_embed
      end

      def setup_maker_attributes(embed)
        embed.url = url
        embed.height = height
        embed.weight = weight
      end

      class MediaParam < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "param"

        install_get_attribute("name", "", true)

        content_setup

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_param
        end

        def setup_maker_attributes(param)
          param.name = name
          param.content = content
        end
      end
    end
  end

  module MediaResponsesModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "responses"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaResponses < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "responses"

      install_have_children_element("response",
                                    MEDIA_URI,
                                    "*",
                                    "#{MEDIA_PREFIX}_response",
                                    "#{MEDIA_PREFIX}_responses")

      def to_a
        media_responses.collect(&:content)
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_responses
      end

      class MediaResponse < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "response"

        content_setup

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_response
        end

        def setup_maker_attributes(response)
          response.content = content
        end
      end
    end
  end

  module MediaBackLinksModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "backLinks"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaBackLinks < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "backLinks"

      install_have_children_element("backLink",
                                    MEDIA_URI,
                                    "*",
                                    "#{MEDIA_PREFIX}_backLink",
                                    "#{MEDIA_PREFIX}_backLinks")

      def to_a
        media_backLinks.collect(&:content)
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_backLinks
      end

      class MediaBackLink < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "backLink"

        content_setup

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_backLink
        end

        def setup_maker_attributes(backLink)
          backLink.content = content
        end
      end
    end
  end

  module MediaStatusModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "status"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaStatus < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "status"

      install_get_attribute("state", "", true, :media_status_state)
      install_get_attribute("reason", "", false)

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_status
      end

      def setup_maker_attributes(status)
        status.state = state
        status.reason = reason
      end
    end
  end

  module MediaPriceModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "price"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaPrice < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "price"

      install_get_attribute("type", "", false, :media_price_type)
      install_get_attribute("info", "", false, :uri)
      install_get_attribute("price", "", false, :float)
      install_get_attribute("currency", "", false) # TODO: ISO 4217

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_price
      end

      def setup_maker_attributes(price)
        price.type = type
        price.info = info
        price.price = price
        price.currency = currency
      end
    end
  end

  module MediaLicenseModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "license"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaLicense < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "license"

      install_get_attribute("type", "", false)
      install_get_attribute("href", "", false, :uri)

      content_setup

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_license
      end

      def setup_maker_attributes(license)
        license.type = type
        license.href = href
        license.content = content
      end
    end
  end

  module MediaSubTitleModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "subTitle"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaSubTitle < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "subTitle"

      install_get_attribute("type", "", false)
      install_get_attribute("lang", "", false)
      install_get_attribute("href", "", false, :uri)

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_subTitle
      end

      def setup_maker_attributes(subTitle)
        subTitle.type = type
        subTitle.lang = lang
        subTitle.href = href
      end
    end
  end

  module MediaPeerLinkModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "peerLink"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaPeerLink < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "peerLink"

      install_get_attribute("type", "", false)
      install_get_attribute("href", "", false, :uri)

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_peerLink
      end

      def setup_maker_attributes(peerLink)
        peerLink.type = type
        peerLink.href = href
      end
    end
  end

  module MediaLocationModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "location"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaLocation < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "location"

      install_get_attribute("description", "", false)
      install_get_attribute("start", "", false)
      install_get_attribute("end", "", false)

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_location
      end

      def setup_maker_attributes(location)
        location.start = start
        location.end = self.end
      end
    end
  end

  module MediaRightsModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "rights"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaRights < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "rights"

      install_get_attribute("status", "", false, :media_rights_status)

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_rights
      end

      def setup_maker_attributes(rights)
        rights.status = status
      end
    end
  end

  module MediaScenesModel
    extend BaseModel

    def self.append_features(klass)
      super
      tag_name = "scenes"
      name = "#{MEDIA_PREFIX}_#{tag_name}"
      klass.install_have_child_element(tag_name, MEDIA_URI, "?", name)
    end

    class MediaScenes < Element
      include RSS09

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "scenes"

      install_have_children_element("scene",
                                    MEDIA_URI,
                                    "*",
                                    "#{MEDIA_PREFIX}_scene",
                                    "#{MEDIA_PREFIX}_scenes")

      def to_a
        media_scenes
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_scenes
      end

      class MediaScene < Element
        include RSS09

        class << self
          def required_prefix
            MEDIA_PREFIX
          end

          def required_uri
            MEDIA_URI
          end
        end

        @tag_name = "scene"

        [
          "Title",
          "Description",
          "StartTime",
          "EndTime",
        ].each do |name|
          element_name = "scene#{name}"
          install_text_element(element_name, "", "?", element_name)
          method_name = name[0].downcase + name[1..-1]
          alias_method method_name, element_name
          alias_method "#{method_name}=", "#{element_name}="
        end

        def full_name
          tag_name_with_prefix(MEDIA_PREFIX)
        end

        private
        def maker_target(target)
          target.new_media_scene
        end

        def setup_maker_attributes(scene)
          scene.title = title
          scene.descrpition = description
          scene.startTime = startTime
          scene.endTime = endTime
        end
      end
    end
  end

  module MediaCommonModel
    extend BaseModel

    COMMON_MODELS = [
      MediaRatingModel,
      MediaTitleModel,
      MediaDescriptionModel,
      MediaThumbnailModel,
      MediaCategoryModel,
      MediaHashModel,
      MediaPlayerModel,
      MediaCreditModel,
      MediaCopyrightModel,
      MediaTextModel,
      MediaRestrictionModel,
      MediaCommunityModel,
      MediaCommentsModel,
      MediaEmbedModel,
      MediaResponsesModel,
      MediaBackLinksModel,
      MediaStatusModel,
      MediaPriceModel,
      MediaLicenseModel,
      MediaSubTitleModel,
      MediaPeerLinkModel,
      MediaLocationModel,
      MediaRightsModel,
      MediaScenesModel,
    ]

    def self.append_features(klass)
      super
      klass.module_eval do
        COMMON_MODELS.each do |model|
          include model
        end

        install_text_element("keywords",
                             MEDIA_URI,
                             "?",
                             "#{MEDIA_PREFIX}_keywords",
                             :csv)

      end
    end
  end

  module MediaContentModel
    extend BaseModel

    def self.append_features(klass)
      super
      var_name = "#{MEDIA_PREFIX}_content"
      klass.install_have_children_element("content", MEDIA_URI, "*", var_name)
    end

    class MediaContent < Element
      include RSS09
      include MediaCommonModel

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "content"

      ATTRIBUTES = [
        ["url"],
        ["fileSize", :integer],
        ["type"],
        ["medium"],
        ["isDefault", :boolean],
        ["expression"],
        ["bitrate", :integer],
        ["framerate", :integer],
        ["samplingrate", :float],
        ["channels", :integer],
        ["duration", :integer],
        ["height", :integer],
        ["width", :integer],
        ["lang"],
      ]
      ATTRIBUTES.each do |name, type|
        install_get_attribute(name, "", false, type)
      end

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_content
      end
    end
  end

  module MediaGroupModel
    extend BaseModel

    def self.append_features(klass)
      super
      var_name = "#{MEDIA_PREFIX}_group"
      klass.install_have_children_element("group", MEDIA_URI, "*", var_name)
    end

    class MediaGroup < Element
      include RSS09
      include MediaCommonModel
      include MediaContentModel

      class << self
        def required_prefix
          MEDIA_PREFIX
        end

        def required_uri
          MEDIA_URI
        end
      end

      @tag_name = "group"

      def full_name
        tag_name_with_prefix(MEDIA_PREFIX)
      end

      private
      def maker_target(target)
        target.new_media_group
      end
    end
  end

  class Rss
    class Channel
      include MediaCommonModel

      class Item
        include MediaCommonModel
        include MediaGroupModel
        include MediaContentModel
      end
    end
  end
end
