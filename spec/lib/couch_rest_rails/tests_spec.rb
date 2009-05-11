require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Tests do
  
  before :each do
    CouchRest.delete(COUCHDB_CONFIG[:full_path]) rescue nil
    CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
    CouchRestRails.views_path = 'vendor/plugins/couchrest-rails/spec/mock/views'
  end
  
  after :all do
    CouchRest.delete(COUCHDB_CONFIG[:full_path]) rescue nil
  end
  
  describe '#setup' do
    
    it 'should delete, add and load fixtures for the test database' do
      
      # Create a dirty db first...
      CouchRestRails::Database.create
      db = CouchRest.database(COUCHDB_CONFIG[:full_path])
      CouchRestRails::Fixtures.load
      db.documents['rows'].size.should == 10
      
      CouchRestRails::Tests.setup
      db.documents['rows'].size.should == 12 # Includes design docs
      db.view('foos/all')['rows'].size.should == 5
    
    end
    
  end
  
  describe '#teardown' do
    
    it 'should delete the test database' do
      CouchRestRails::Tests.setup
      db = CouchRest.database(COUCHDB_CONFIG[:full_path])
      db.documents['rows'].size.should == 12 # Includes design docs
      CouchRestRails::Tests.teardown
      lambda {CouchRest.get(COUCHDB_CONFIG[:full_path])}.should raise_error('Resource not found')
    end
    
  end
    
end