require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Tests do
  
  before :each do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
    CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
  end
  
  after :all do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
  end
  
  describe '#setup' do
    
    it 'should drop, add and load fixtures for the test database' do
      CouchRestRails.create
      db = CouchRest.database(COUCHDB_SERVER[:instance])
      CouchRestRails::Fixtures.load
      db.documents['rows'].size.should == 10
      CouchRestRails::Tests.setup
      db.documents['rows'].size.should == 10
    end
    
  end
  
  describe '#teardown' do
    
    it 'should drop the test database' do
      CouchRestRails::Tests.setup
      db = CouchRest.database(COUCHDB_SERVER[:instance])
      db.documents['rows'].size.should == 10
      CouchRestRails::Tests.teardown
      lambda {CouchRest.get(COUCHDB_SERVER[:instance])}.should raise_error('Resource not found')
    end
    
  end
    
end