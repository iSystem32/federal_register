class FederalRegister::Agency < FederalRegister::Base
  add_attribute :agency_url,
                :child_ids,
                :description,
                :json_url,
                :logo,
                :name,
                :raw_name,
                :recent_articles_url,
                :short_name,
                :slug,
                :url
  add_attribute :id,
                :parent_id,
                :type => :integer

  def self.all(options={})
    get_options = {}
    get_options.merge!(:query => {:fields => options[:fields]}) if options[:fields]

    response = get('agencies.json', get_options).parsed_response

    response.map do |hsh|
      new(hsh, :full => true)
    end
  end

  def self.find(id_or_slug, options={})
    slug = URI.encode(id_or_slug.to_s)

    if options[:fields].present?
      response = get("agencies/#{slug}.json", :query => {:fields => options[:fields]}).parsed_response

      if response.is_a?(Hash)
        new(response)
      else
        response.map do |hsh|
          new(hsh)
        end
      end
    else
      response = get("agencies/#{slug}.json").parsed_response

      if response.is_a?(Hash)
        new(response, :full => true)
      else
        response.map do |hsh|
          new(hsh, :full => true)
        end
      end
    end
  end

  def self.suggestions(args={})
    response = get("agencies/suggestions", query: args).parsed_response

    response.map do |hsh|
      new(hsh, :full => true)
    end
  end

  def logo_url(size)
    if attributes.has_key?("logo")
      attributes["logo"]["#{size}_url"] || raise("size '#{size}' not a valid image size")
    end
  end
end
