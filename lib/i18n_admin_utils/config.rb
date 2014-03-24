require 'active_support/core_ext/module/attribute_accessors'

module I18nAdminUtils
  module Config
    class << self
      attr_accessor :translation_model
      attr_accessor :reload_translation_after_update
      attr_accessor :locales
      attr_accessor :search_folders
      attr_accessor :search_folders_exclude
      attr_accessor :yml_file

      def reset
        @translation_model = 'Translation'
        @reload_translation_after_update = true
        @locales = ['en']
        @search_folders = ["#{Rails.root}/app"]
        @search_folders_exclude = []
        @yml_file = ''
      end


      def translation_model
        if @translation_model.is_a? String
          @translation_model.constantize
        else
          @translation_model
        end
      end

      def backend=(value)
        @backend = value.to_s
      end

      def backend
        if @backend.nil? or @backend.blank?
          i18n_backend = I18n.backend.class.to_s
          if i18n_backend == 'I18n::Backend::Chain' #If the backend is a chain but no backend was specified then we take the first one
            i18n_backend = I18n.backend.backends.first.class.to_s
          end
          if i18n_backend == 'I18n::Backend::ActiveRecord'
            @backend = 'I18n::Backend::ActiveRecord'
          elsif i18n_backend == 'I18n::Backend::Simple'
            @backend = 'I18n::Backend::Simple'
          else
            raise Exception, "I18nAdminUtils, backend #{i18n_backend} not supported!"
          end
        end
        @backend
      end
    end
    reset
  end
end