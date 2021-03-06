module I18nAdminUtils
  class TranslationController < ApplicationController
    def index
    end

    def edit
      if params[:key].nil?
        i18n_redirect('No key specified', false)
      else
        key = params[:key]
        locale = params[:locale]
        translation = params[:value]
        if locale.nil?
          if key.include? '.'
            split = key.split('.', 2)
            locale = split[0]
            key = split[1]
          else
            i18n_redirect('No locale specified', false)
            return
          end
        end
        I18nAdminUtils::Backend::Manager.save_translation(locale, key, translation)
        i18n_redirect('Translation edited with success')
      end
    end

    def show
      if params[:translation].nil?
        render :text => 'Error no params given'
      else
        translation = I18nAdminUtils::Translation.from_hash(params[:translation])
        if translation.key.nil?
          render :text => 'Error no key given'
        else
          render :partial => 'show', :locals => {:translation => translation}
        end
      end
    end

    #Return a list of all the missing translation
    def missing_list
      translations = I18nAdminUtils::SearchTranslation.search
      render :partial => 'missing_list', :layouts => false, :locals => {:translations => translations}
    end

    def list_element
      if params[:translation].nil?
        render :text => 'Error no translation given'
      else
        translation = I18nAdminUtils::Translation.from_hash(params[:translation])
        if translation.key.nil?
          render :text => 'Error no key given'
        else
          render :partial => 'list_element', :locals => {:translation => translation}
        end

      end
    end

    def i18n_redirect(message, success = true)
      if request.xhr?
        render :json => {:success => success, :message => message}
      else
        if success
          redirect_to :back, :notice => message
        else
          redirect_to :back, :alert => message
        end
      end
    end
  end
end