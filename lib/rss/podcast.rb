# frozen_string_literal: false
require 'rss/2.0'

module RSS
  # The prefix for the Podcast XML namespace.
  PODCAST_PREFIX = 'podcast'
  # The URI of the Podcast Namespace specification.
  PODCAST_URI = 'https://podcastindex.org/namespace/1.0'

  # Spec: https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md

  Rss.install_ns(PODCAST_PREFIX, PODCAST_URI)

  module PodcastModelUtils
    include Utils

    def def_class_accessor(klass, name, type, *args)
        normalized_name = name.gsub(/-/, "_")
      full_name = "#{PODCAST_PREFIX}_#{normalized_name}"
      klass_name = "Podcast#{Utils.to_class_name(normalized_name)}"

      case type
      when :element, :attribute
        klass::ELEMENTS << full_name
        def_element_class_accessor(klass, name, full_name, klass_name, *args)
      when :elements
        klass::ELEMENTS << full_name
        def_elements_class_accessor(klass, name, full_name, klass_name, *args)
      else
        klass.install_must_call_validator(PODCAST_PREFIX, PODCAST_URI)
        klass.install_text_element(normalized_name, PODCAST_URI, "?",
                                   full_name, type, name)
      end
    end

    def def_element_class_accessor(klass, name, full_name, klass_name,
                                   recommended_attribute_name=nil)
      klass.install_have_child_element(name, PODCAST_PREFIX, "?", full_name)
    end

    def def_elements_class_accessor(klass, name, full_name, klass_name,
                                    plural_name, recommended_attribute_name=nil)
      full_plural_name = "#{PODCAST_PREFIX}_#{plural_name}"
      klass.install_have_children_element(name, PODCAST_PREFIX, "*",
                                          full_name, full_plural_name)
    end
  end

  module PodcastBaseModel
    extend PodcastModelUtils

    ELEMENTS = []

    ELEMENT_INFOS = [
      ["person", :elements],
      ["location"],
    ]
  end

  module PodcastChannelModel
    extend BaseModel
    extend PodcastModelUtils
    include PodcastBaseModel

    ELEMENTS = []

    class << self
      def append_features(klass)
        super

        return if klass.instance_of?(Module)
        ELEMENT_INFOS.each do |name, type, *additional_infos|
          def_class_accessor(klass, name, type, *additional_infos)
        end
      end
    end

    ELEMENT_INFOS = [
      ["locked", :yes_other],
      ["funding", :attribute, "url"], 
    ] + PodcastBaseModel::ELEMENT_INFOS

  end

  module PodcastItemModel
    extend BaseModel
    extend PodcastModelUtils
    include PodcastBaseModel

    class << self
      def append_features(klass)
        super

        return if klass.instance_of?(Module)
        ELEMENT_INFOS.each do |name, type|
          def_class_accessor(klass, name, type)
        end
      end
    end

    ELEMENT_INFOS = PodcastBaseModel::ELEMENT_INFOS + [
      ["transcript", :elements, "content"], 
      ["chapters", :attribute, "url"], 
      ["season"],
      ["episode"]
    ]


    class PodcastTranscript < Element
      include RSS09

      @tag_name = "transcript"

      class << self
        def required_prefix
          PODCAST_PREFIX
        end

        def required_uri
          PODCAST_URI
        end
      end

      [
        ["url", "", true],
        ["type", "", true],
        ["language", "", false],
        ["rel", "", false],
      ].each do |name, uri, required|
        install_get_attribute(name, uri, required)
      end

      def initialize(*args)
        if Utils.element_initialize_arguments?(args)
          super
        else
          super()
          self.url = args[0]
          self.type = args[1]
          self.language = args[2]
          self.rel = args[3]
        end
      end

      def full_name
        tag_name_with_prefix(PODCAST_PREFIX)
      end

      private
      def maker_target(target)
        if url and type
          target.url = url
          target.type = type
          target.language = language
          target.rel = rel
        else
          nil
        end
      end

      def setup_maker_attributes(transcript)
        super(transcript)
        transcript.url = url
        transcript.type = type
        transcript.language = language
        transcript.rel = rel
      end
    end
  end

  class PodcastSoundbite < Element
    include RSS09

    @tag_name = "soundbite"

    class << self
      def required_prefix
        PODCAST_PREFIX
      end

      def required_uri
        PODCAST_URI
      end
    end

    [
      ["startTime", "", true],
      ["duration", "", true],
    ].each do |name, uri, required|
      install_get_attribute(name, uri, required)
    end

    def initialize(*args)
      if Utils.element_initialize_arguments?(args)
        super
      else
        super()
        self.startTime = args[0]
        self.duration = args[1]
        self.content = args[2]
      end
    end

    def full_name
      tag_name_with_prefix(PODCAST_PREFIX)
    end
  end

  class PodcastPerson < Element
    include RSS09

    @tag_name = "person"

    class << self
      def required_prefix
        PODCAST_PREFIX
      end

      def required_uri
        PODCAST_URI
      end
    end

    [
      ["role", "", false],
      ["group", "", false],
      ["img", "", false],
      ["ref", "", false],
    ].each do |name, uri, required|
      install_get_attribute(name, uri, required)
    end

    def initialize(*args)
      if Utils.element_initialize_arguments?(args)
        super
      else
        super()
        self.content = args[0]
        self.role = args[1]
        self.group = args[2]
        self.img = args[3]
        self.ref = args[3]
      end
    end

    def full_name
      tag_name_with_prefix(PODCAST_PREFIX)
    end
  end

  class Rss
    class Channel
      include PodcastChannelModel
      class Item; include PodcastItemModel; end
    end
  end

  element_infos = PodcastChannelModel::ELEMENT_INFOS + PodcastItemModel::ELEMENT_INFOS
  element_infos.each do |name, type|
    case type
    when :element, :elements, :attribute
      class_name = Utils.to_class_name(name)
      BaseListener.install_class_name(PODCAST_URI, name, "Podcast#{class_name}")
    else
      accessor_base = "#{PODCAST_PREFIX}_#{name.gsub(/-/, '_')}"
      BaseListener.install_get_text_element(PODCAST_URI, name, accessor_base)
    end
  end
end
