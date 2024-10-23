require File.dirname(__FILE__) + '/spec_helper'

describe FederalRegister::PublicInspectionDocument do
  describe ".find" do
    it "fetches the document by its document number" do
      document_number = "2010-213"
      stub_request(
        :get,
        "https://www.federalregister.gov/api/v1/public-inspection-documents/#{document_number}.json"
      )
      .to_return(
        body: {:title => "Important Notice"}.to_json,
        headers: { 'Content-Type' => 'application/json' },
        status: 200
      )


      FederalRegister::PublicInspectionDocument.find(document_number).title.should == 'Important Notice'
    end

    it "throws an error when a document doesn't exist" do
      document_number = "some-random-document"
      stub_request(
        :get,
        "https://www.federalregister.gov/api/v1/public-inspection-documents/#{document_number}.json"
      )
      .to_return(
        headers: { 'Content-Type' => 'text/json' },
        status: 404
      )

      lambda{ FederalRegister::PublicInspectionDocument.find(document_number) }.should raise_error FederalRegister::Client::RecordNotFound
    end
  end

  describe ".find_all" do
    it "fetches multiple matching documents" do
      stub_request(:get, "https://www.federalregister.gov/api/v1/public-inspection-documents/abc,def.json").
        to_return(status: 200, body: {:results => [{:document_number => "abc"}, {:document_number => "def"}]}.to_json,         headers: { 'Content-Type' => 'text/json' })

      result_set = FederalRegister::PublicInspectionDocument.find_all('abc','def')
      result_set.results.map(&:document_number).sort.should === ['abc','def']
    end
  end

  describe ".available_on" do
    it "fetches the document on PI on a given date" do
      params = URI.encode_www_form([["conditions[available_on]", "2011-10-15"]])

      stub_request(
        :get,
        "https://www.federalregister.gov/api/v1/public-inspection-documents.json?#{params}",
      )
      .to_return(
        body: {:results => [{:document_number => "abc"}, {:document_number => "def"}]}.to_json,
        headers: { 'Content-Type' => 'text/json' },
        # status: 200
      )

      result_set = FederalRegister::PublicInspectionDocument.available_on(Date.parse('2011-10-15'))
      result_set.results.map(&:document_number).sort.should === ['abc','def']
    end
  end

  describe ".current" do
    it "fetches the PI documents from the current issue" do
      stub_request(
        :get,
        "https://www.federalregister.gov/api/v1/public-inspection-documents/current.json",
      )
      .to_return(
        body: {:results => [{:document_number => "abc"}, {:document_number => "def"}]}.to_json,
        headers: { 'Content-Type' => 'text/json' },
        # status: 200
      )

      result_set = FederalRegister::PublicInspectionDocument.current
      result_set.results.map(&:document_number).sort.should === ['abc','def']
    end
  end
end
