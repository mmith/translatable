module Translatable
  
  mattr_accessor :available_locales
  self.available_locales = [:en, :fr, :de]
  
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def acts_as_translatable
      accepts_nested_attributes_for :translations
      after_save :init_translations
      
      send :include, InstanceMethods
    end
  end
  
  module InstanceMethods
    def init_translations
      Translatable.available_locales.reject{|key| key == :root }.each do |locale|
        translation = self.translations.find_by_locale locale.to_s
        if translation.nil?          
          translations.build :locale => locale
          save
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Translatable