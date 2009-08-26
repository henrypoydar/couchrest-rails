require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Views do

  before :each do
    CouchRest.delete(COUCHDB_CONFIG[:full_path]) rescue nil
  end
  
  after :all do
    CouchRest.delete(COUCHDB_CONFIG[:full_path]) rescue nil
  end

  describe '#create' do
  
    it 'should create a CouchDB database for the current environment' do
      CouchRestRails::Database.create('foo')
      res = CouchRest.get('foo')
      res['db_name'].should == COUCHDB_CONFIG[:database]
    end

    it 'should do nothing and display a message if the database already exists' do
      CouchRest.database!("foo")
      res = CouchRestRails::Database.create
      res.should =~ /already exists/i
    end

  end
  
  describe "#delete" do
    
    it 'should delete the CouchDB database for the current environment' do
      CouchRest.database!("#{COUCHDB_CONFIG[:full_path]}")
      CouchRestRails::Database.delete
      lambda {CouchRest.get(COUCHDB_CONFIG[:full_path])}.should raise_error('Resource not found')
    end

    it 'should do nothing and display a message if the database does not exist' do
      res = CouchRestRails::Database.delete
      res.should =~ /does not exist/i
    end
    
  end

end