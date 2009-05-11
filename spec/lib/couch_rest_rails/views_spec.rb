require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Views do
  
  before :each do
    CouchRestRails.views_path = 'vendor/plugins/couchrest-rails/spec/mock/views'
    CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
    
  end
  
  after :all do
    CouchRestRails::Tests.teardown
  end
  
  describe '#push' do
  
    it "should push the views in CouchRestRails.views_path to a design document for the database" do
      CouchRestRails::Tests.setup # Pushes views
      db = CouchRest.database(COUCHDB_CONFIG[:full_path])
      db.view('foos/all')['rows'].size.should == 5
    end
  
  end
  
end