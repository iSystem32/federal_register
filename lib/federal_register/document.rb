class FederalRegister::Document < FederalRegister::Base
  extend FederalRegister::Utilities
  extend FederalRegister::DocumentUtilities

  add_attribute :abstract,
                :abstract_html_url,
                :action,
                :agencies,
                :agency_names,
                :body_html_url,
                :cfr_references,
                :citation,
                :comment_url,
                :corrections,
                :correction_of,
                :dates,
                :disposition_notes,
                :docket_id,
                :docket_ids,
                :document_number,
                :end_page,
                :excerpts,
                :executive_order_notes,
                :executive_order_number,
                :full_text_xml_url,
                :html_url,
                :images,
                :json_url,
                :mods_url,
                :page_views,
                :pdf_url,
                :president,
                :proclamation_number,
                :public_inspection_pdf_url,
                :regulation_id_number_info,
                :regulation_id_numbers,
                :regulations_dot_gov_info,
                :regulations_dot_gov_url,
                :significant,
                :start_page,
                :subtype,
                :raw_text_url,
                :title,
                :toc_subject,
                :toc_doc,
                :type,
                :volume

  add_attribute :comments_close_on,
                :effective_on,
                :publication_date,
                :signing_date,
                :type => :date

  def self.search(args)
    FederalRegister::ResultSet.fetch("documents.json", :query => args, :result_class => self)
  end

  def self.search_metadata(args)
    FederalRegister::ResultSet.fetch("documents.json", :query => args.merge(:metadata_only => '1'), :result_class => self)
  end

  def self.find(document_number, options={})
    query = {}
    
    if options[:publication_date].present?
      publication_date = options[:publication_date]
      publication_date = publication_date.is_a?(Date) ? publication_date.to_s(:iso) : publication_date
      
      query.merge!(:publication_date => publication_date)
    end

    if options[:fields].present?
      query.merge!(:fields => options[:fields])
    end

    attributes = get("documents/#{document_number}.json", :query => query).parsed_response
    new(attributes, :full => true)
  end

  def self.find_all_base_path
    'documents'
  end

  def agencies
    attributes["agencies"].map do |attr|
      FederalRegister::Agency.new(attr)
    end
  end

  %w(full_text_xml abstract_html body_html raw_text mods).each do |file_type|
    define_method file_type do
      response = Faraday.get(send("#{file_type}_url"))
      if response.success?
        response.body
      elsif response.status == 404
        nil
      else
        raise send("#{file_type}_url").inspect
      end
    end
  end

  def images
    if attributes["images"]
      attributes["images"].map do |attributes|
        FederalRegister::DocumentImage.new(attributes)
      end
    else
      []
    end
  end

  def page_views
    if attributes["page_views"]
      last_updated = begin
        DateTime.parse(attributes["page_views"]["last_updated"])
      rescue
        nil
      end

      {
        count: attributes["page_views"]["count"],
        last_updated: last_updated
      }
    end
  end
end
