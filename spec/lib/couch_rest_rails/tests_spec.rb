require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Tests do
  
  before :each do
    setup_foo_bars
  end
  
  after :all do
    cleanup_foo_bars
  end
  
  describe '#setup' do
    
    it 'should delete, add, push views and load fixtures for the specified database' do
      
      CouchRestRails::Database.create('foo')
      db = CouchRest.database(@foo_db_url)
      CouchRestRails::Fixtures.load('foo')
      db.documents['rows'].size.should == 10
      
      CouchRestRails::Tests.setup('foo')
      db.documents['rows'].size.should == 12 # Includes design docs
      db.view('foos/all')['rows'].size.should == 5
    
    end
    
    it 'should delete, add, push views and load fixtures for all databases if none are specified' do
      CouchRestRails::Database.create('foo')
      dbf = CouchRest.database(@foo_db_url)
      dbb = CouchRest.database(@bar_db_url)
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