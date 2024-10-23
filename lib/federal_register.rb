require 'rubygems'
require 'faraday'

module FederalRegister
end

require "federal_register/utilities.rb"
require "federal_register/client.rb"
require "federal_register/base.rb"

require "federal_register/result_set.rb"
require "federal_register/public_inspection_issue_result_set.rb"
require "federal_register/facet_result_set.rb"

require "federal_register/document_utilities.rb"
require "federal_register/agency.rb"
require "federal_register/document.rb"
require "federal_register/article.rb"
require "federal_register/document_image.rb"
require "federal_register/document_search_details.rb"

require "federal_register/facet.rb"
require "federal_register/facet/agency.rb"
require "federal_register/facet/presidential_document_type.rb"
require "federal_register/facet/topic.rb"
require "federal_register/facet/document.rb"

require "federal_register/facet/document/frequency.rb"
require "federal_register/facet/document/daily.rb"
require "federal_register/facet/document/weekly.rb"
require "federal_register/facet/document/monthly.rb"
require "federal_register/facet/document/quarterly.rb"
require "federal_register/facet/document/yearly.rb"

require "federal_register/facet/document/agency.rb"
require "federal_register/facet/document/section.rb"
require "federal_register/facet/document/topic.rb"
require "federal_register/facet/document/type.rb"

require "federal_register/facet/public_inspection_document.rb"
require "federal_register/facet/public_inspection_document/agencies.rb"
require "federal_register/facet/public_inspection_document/agency.rb"
require "federal_register/facet/public_inspection_document/type.rb"

require "federal_register/facet/public_inspection_issue.rb"
require "federal_register/facet/public_inspection_issue/daily.rb"
require "federal_register/facet/public_inspection_issue/daily_filing.rb"
require "federal_register/facet/public_inspection_issue/type.rb"
require "federal_register/facet/public_inspection_issue/type_filing.rb"

require "federal_register/highlighted_document.rb"
require "federal_register/public_inspection_document.rb"
require "federal_register/public_inspection_document_search_details.rb"
require "federal_register/section.rb"
require "federal_register/suggested_search.rb"
require "federal_register/topic.rb"
