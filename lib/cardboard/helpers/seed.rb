require 'active_support/concern'

module Cardboard

  module Seed
    extend ActiveSupport::Concern

    def self.populate_pages(pages)
      pages ||= {}
      pages.each do |id, page|

        db_page = Cardboard::Page.where(identifier: id.to_s).first_or_initialize
        db_page.update_attributes!(page.filter(:title, :parent_id), :without_protection => true) 

        self.populate_parts(page[:parts], db_page)
      end

      for remove_page in Cardboard::Page.all.map(&:identifier) - pages.map{|k,v|k.to_s}
        Cardboard::Page.where(identifier: remove_page).first.destroy
      end

      Cardboard::Page.create(title: "index", path: "/") if Cardboard::Page.root.nil?
    end


    def self.populate_parts(page_parts, db_page)
      page_parts ||= {}
      page_parts.each do |id, part|
        db_part = db_page.parts.where(identifier: id.to_s).first_or_initialize
        db_part.update_attributes!(part.filter(:repeatable), :without_protection => true) 

        db_part.subparts.first_or_create! 
        db_part.subparts.each do |db_part|
          self.populate_fields(part[:fields], db_part)
        end
        # for remove_field in db_part.fields.map(&:identifier) - part[:fields].map{|k,v|k.to_s}  
        #   db_part.fields.where(identifier: remove_field).first.destroy
        # end
      end
      for remove_part in db_page.parts.map(&:identifier) - page_parts.map{|k,v|k.to_s}
        db_page.parts.where(identifier: remove_part).first.destroy
      end
    end

    def self.populate_fields(fields, object)
      fields ||= {}
      fields.each do |id, field|
        field.reverse_merge!(type: "string")
        db_field = object.fields.where(identifier: id.to_s).first_or_initialize
        db_field.seeding = true
        db_field.update_attributes!(field, :without_protection => true) 
      end
      #remove fields no longer in the seed file
      for remove_field in object.fields.map(&:identifier) - fields.map{|k,v|k.to_s}
        object.fields.where(identifier: remove_field).first.destroy
      end
    end

    def self.populate_settings(settings)
      if settings
        db_settings = Cardboard::Setting.first_or_create
        self.populate_fields(settings, db_settings)
      end
      Cardboard::Setting.add("company_name", type: "string", default: Rails.application.class.name.split("::").first.titlecase, position: 0)
      Cardboard::Setting.add("google_analytics", type: "string", position: 1)
    end
    
  end
end