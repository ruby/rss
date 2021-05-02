# frozen_string_literal: false
require_relative '../podcast'
require_relative '2.0'

module RSS
  module Maker
    module PodcastBaseModel
      def def_class_accessor(klass, name, type, *args)
        name = name.gsub(/-/, "_").gsub(/^itunes_/, '')
        full_name = "#{RSS::ITUNES_PREFIX}_#{name}"
        case type
        when nil
          klass.def_other_element(full_name)
        when :yes_other
          def_yes_other_accessor(klass, full_name)
        when :csv
          def_csv_accessor(klass, full_name)
        when :element, :attribute
          recommended_attribute_name, = *args
          klass_name = "Podcast#{Utils.to_class_name(name)}"
          klass.def_classed_element(full_name, klass_name,
                                    recommended_attribute_name)
        when :elements
          plural_name, recommended_attribute_name = args
          plural_name ||= "#{name}s"
          full_plural_name = "#{RSS::PODCAST_PREFIX}_#{plural_name}"
          klass_name = "Podcast#{Utils.to_class_name(name)}"
          plural_klass_name = "Podcast#{Utils.to_class_name(plural_name)}"
          def_elements_class_accessor(klass, name, full_name, full_plural_name,
                                      klass_name, plural_klass_name,
                                      recommended_attribute_name)
        end
      end

      def def_yes_other_accessor(klass, full_name)
        klass.def_other_element(full_name)
        klass.module_eval(<<-EOC, __FILE__, __LINE__ + 1)
          def #{full_name}?
            Utils::YesOther.parse(@#{full_name})
          end
        EOC
      end

      def def_csv_accessor(klass, full_name)
        klass.def_csv_element(full_name)
      end

      def def_elements_class_accessor(klass, name, full_name, full_plural_name,
                                      klass_name, plural_klass_name,
                                      recommended_attribute_name=nil)
        if recommended_attribute_name
          klass.def_classed_elements(full_name, recommended_attribute_name,
                                     plural_klass_name, full_plural_name)
        else
          klass.def_classed_element(full_plural_name, plural_klass_name)
        end
        klass.module_eval(<<-EOC, __FILE__, __LINE__ + 1)
          def new_#{full_name}(text=nil)
            #{full_name} = @#{full_plural_name}.new_#{name}
            #{full_name}.text = text
            if block_given?
              yield #{full_name}
            else
              #{full_name}
            end
          end
        EOC
      end

      class PodcastPersonBase < Base
        %w(name role group img href).each do |name|
          add_need_initialize_variable(name)
          attr_accessor(name)
        end

        def to_feed(feed, current)
          if current.respond_to?(:podcast_person=)
            _not_set_required_variables = not_set_required_variables
            if (required_variable_names - _not_set_required_variables).empty?
              return
            end

            unless have_required_values?
              raise NotSetError.new("maker.*.person",
                                    _not_set_required_variables)
            end
            person = current.class::PodcastPerson.new
            person.content = @name
            person.role = @role if @role.present?
            current.person << person
            set_parent(person, current)
          end
        end

        private
        def required_variable_names
          %w(name)
        end
      end
    end

    module PodcastChannelModel
      extend PodcastBaseModel

      class << self
        def append_features(klass)
          super

          ::RSS::PodcastChannelModel::ELEMENT_INFOS.each do |name, type, *args|
            def_class_accessor(klass, name, type, *args)
          end
        end
      end
    end

    module PodcastItemModel
      extend PodcastBaseModel

      class << self
        def append_features(klass)
          super

          ::RSS::PodcastItemModel::ELEMENT_INFOS.each do |name, type, *args|
            def_class_accessor(klass, name, type, *args)
          end
        end
      end

      class PodcastTranscriptBase < Base
        add_need_initialize_variable("url")
        attr_accessor("url")

        def to_feed(feed, current)
          if @url and @type and current.respond_to?(:transcript)
            transcript = current.class::PodcastTranscript.new
            transcript.url = @url
            transcript.type = @type
            current.transcript << transcript
            set_parent(transcript, current)
          end
        end
      end
    end

    class ChannelBase
      include Maker::PodcastChannelModel

      class PodcastPerson < PodcastPersonBase; end
    end

    class ItemsBase
      class ItemBase
        include Maker::PodcastItemModel
        class PodcastTranscript < PodcastTranscriptBase; end
      end
    end
  end
end
