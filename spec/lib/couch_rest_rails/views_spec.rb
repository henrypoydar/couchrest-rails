require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Views do
  
  before :each do
    CouchRestRails.views_path = 'vendor/plugins/couchrest-rails/spec/mock/views'
    CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
    CouchRestRails::Tests.setup
  end
  
  after :all do
    CouchRestRails::Tests.teardown
  end
  
  it "should push the views in CouchRestRails.views_path to a design document for the database" do
    db = CouchRest.database(COUCHDB_SERVER[:instance])
    #CouchRestRails::Views.push
    db.view('foos/all')['rows'].size.should == 5
  end
  
end