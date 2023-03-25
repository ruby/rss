# frozen_string_literal: false

require_relative "../media"
require_relative "2.0"

module RSS
  module Maker
    module MediaCommonModel
      class << self
        def append_features(klass)
          super
          model_infos.each do |model, class_name, method_name|
            if model == ::RSS::MediaThumbnailModel
              klass.def_classed_elements(method_name, "url")
            elsif model == ::RSS::MediaHashModel
              klass.def_classed_elements(method_name,
                                         "content",
                                         "#{class_name}es",
                                         "#{method_name}es")
            elsif model == ::RSS::MediaCreditModel
              klass.def_classed_elements(method_name, "content")
            elsif model == ::RSS::MediaTextModel
              klass.def_classed_elements(method_name, "content")
            elsif model == ::RSS::MediaRestrictionModel
              klass.def_classed_elements(method_name, "content")
            else
              klass.def_classed_element(method_name, class_name)
            end
          end
          klass.def_csv_element("media_keywords")
        end

        def model_infos
          ::RSS::MediaCommonModel::COMMON_MODELS.collect do |model|
            class_name = model.name.split("::").last.gsub(/Model\z/, "")
            method_name = class_name.gsub(/\AMedia[A-Z]/) do |matched|
              "media_#{matched[-1].downcase}"
            end
            [model, class_name, method_name]
          end
        end
      end

      class MediaThumbnails < Base
        def_array_element("media_thumbnail")
      end

      class MediaHashes < Base
        def_array_element("media_hash", "media_hashes")
      end

      class MediaCredits < Base
        def_array_element("media_credit")
      end

      class MediaTexts < Base
        def_array_element("media_text")
      end

      class MediaRestrictions < Base
        def_array_element("media_restriction")
      end

      class MediaBase < Base
        class << self
          def init(feed_class)
            # TODO
            if feed_class.const_defined?(:ATTRIBUTES)
              feed_class::ATTRIBUTES.each do |name,|
                add_need_initialize_variable(name)
                attr_accessor(name)
              end
            end
            if feed_class.have_content?
              add_need_initialize_variable(:content)
              attr_accessor(:content)
            end
          end
        end

        def to_feed(feed, current)
          feed_class = self.class.feed_class
          values = {}
          # TODO
          if feed_class.const_defined?(:ATTRIBUTES)
            feed_class::ATTRIBUTES.each do |name, type|
              value = __send__(name)
              next if value.nil?
              values[name] = value
            end
          end
          if feed_class.have_content?
            values["content"] = content if content
          end
          if values.empty? and self.class.other_elements.empty?
            return
          end

          target = feed_class.new
          values.each do |name, value|
            target.__send__("#{name}=", value)
          end
          setup_other_elements(feed, target)
          if values.empty?
            have_other_element = self.class.other_elements.any? do |element|
              not target.__send__(element).nil?
            end
            return unless have_other_element
          end

          case feed_class.tag_name
          when "thumbnail"
            current.media_thumbnails << target
          when "hash"
            current.media_hashes << target
          when "credit"
            current.media_credits << target
          when "text"
            current.media_texts << target
          when "restriction"
            current.media_restrictions << target
          else
            current.__send__("media_#{target.tag_name}=", target)
          end
        end
      end

      model_infos.each do |model, class_name, method_name|
        maker_class = Class.new(MediaBase) do
          singleton_class.define_method(:feed_class) do
            model.const_get(class_name)
          end
          init(feed_class)

          if model == ::RSS::MediaCommunityModel
            def_classed_element("media_starRating")
            star_rating_class = Class.new(MediaBase) do
              class << self
                def feed_class
                  ::RSS::MediaCommunityModel::MediaCommunity::MediaStarRating
                end
              end
              init(feed_class)
            end
            const_set("MediaStarRating", star_rating_class)

            def_classed_element("media_statistics")
            statistics_class = Class.new(MediaBase) do
              class << self
                def feed_class
                  ::RSS::MediaCommunityModel::MediaCommunity::MediaStatistics
                end
              end
              init(feed_class)
            end
            const_set("MediaStatistics", statistics_class)

            def_other_element("media_tags")
          end
        end
        if model == ::RSS::MediaThumbnailModel
          MediaThumbnails.const_set(class_name, maker_class)
        elsif model == ::RSS::MediaHashModel
          MediaHashes.const_set(class_name, maker_class)
        elsif model == ::RSS::MediaCreditModel
          MediaCredits.const_set(class_name, maker_class)
        elsif model == ::RSS::MediaTextModel
          MediaTexts.const_set(class_name, maker_class)
        elsif model == ::RSS::MediaRestrictionModel
          MediaRestrictions.const_set(class_name, maker_class)
        else
          const_set(class_name, maker_class)
        end
      end
    end

    module MediaItemModel
      class << self
        def def_class_accessor(klass, name, type, *args)
          name = name.gsub(/-/, "_").gsub(/^media_/, '')
          full_name = "#{RSS::MEDIA_PREFIX}_#{name}"
          case type
          when nil
            klass.def_other_element(full_name)
          when :yes_other
            def_yes_other_accessor(klass, full_name)
          when :explicit_clean_other
            def_explicit_clean_other_accessor(klass, full_name)
          when :itunes_episode
            def_itunes_episode_accessor(klass, full_name)
          when :csv
            def_csv_accessor(klass, full_name)
          when :element, :attribute
            recommended_attribute_name, = *args
            klass_name = "Media#{Utils.to_class_name(name)}"
            klass.def_classed_element(full_name, klass_name,
                                      recommended_attribute_name)
          when :elements
            plural_name, recommended_attribute_name = args
            plural_name ||= "#{name}s"
            full_plural_name = "#{RSS::ITUNES_PREFIX}_#{plural_name}"
            klass_name = "Media#{Utils.to_class_name(name)}"
            plural_klass_name = "Media#{Utils.to_class_name(plural_name)}"
            def_elements_class_accessor(klass, name, full_name, full_plural_name,
                                        klass_name, plural_klass_name,
                                        recommended_attribute_name)
          end
        end

        def append_features(klass)
          super

          klass.include(MediaCommonModel)
          klass.def_classed_elements("media_content", "MediaContent")
        end
      end

      class MediaContents < Base
        def_array_element("media_content")

        class MediaContent < Base
          ::RSS::MediaContentModel::MediaContent::ATTRIBUTES.each do |name, type|
            add_need_initialize_variable(name)
            attr_accessor(name)
          end

          def to_feed(feed, current)
            values = {}
            ::RSS::MediaContentModel::MediaContent::ATTRIBUTES.each do |name, type|
              value = __send__(name)
              next if value.nil?
              values[name] = value
            end
            return if values.empty?

            media_content = current.class::MediaContent.new
            values.each do |name, value|
              media_content.__send__("#{name}=", value)
            end
            current.media_contents << media_content
          end
        end
      end
    end

    class ItemsBase
      class ItemBase
        include Maker::MediaItemModel
      end
    end
  end
end
