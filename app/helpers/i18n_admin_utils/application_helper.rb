module I18nAdminUtils
  module ApplicationHelper

    #Show the number of translation missing with colorization
    def translation_missing_icon(translation)
      missing_translations = translation.missing_translations
      color_id = (missing_translations.size.to_f/translation.translations.size.to_f*5).ceil-1
      if missing_translations.size == 0
        content_tag 'span', '', :class => 'glyphicon glyphicon-ok greentext',
                    :title => 'This key has been translated in all languages', :rel => 'tooltip'
      else
        content_tag 'span', "(#{missing_translations.size})", :class => "color-range-#{color_id} bold",
                    :title => missing_translations.keys.join(','), :rel => 'tooltip'
      end

    end
  end
end
