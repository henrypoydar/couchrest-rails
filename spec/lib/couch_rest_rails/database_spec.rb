require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Views do

  before :each do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
  end
  
  after :all do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
  end

  describe '#create' do
  
    it 'should create a CouchDB database for the current environment' do
      CouchRestRails::Database.create
      res = CouchRest.get(COUCHDB_SERVER[:instance])
      res['db_name'].should == COUCHDB_SERVER[:database]
    end

    it 'should do nothing and display a message if the database already exists' do
      CouchRest.database!("#{COUCHDB_SERVER[:instance]}")
      res = CouchRestRails::Database.create
      res.should =~ /already exists/i
    end

  end
  
  describe "#delete" do
    
    it 'should delete the CouchDB database for the current environment' do
      CouchRest.database!("#{COUCHDB_SERVER[:instance]}")
      CouchRestRails::Database.delete
      lambda {CouchRest.get(COUCHDB_SERVER[:instance])}.should raise_error('Resource not found')
    end

    it 'should do nothing and display a message if the database does not exist' do
      res = CouchRestRails::Database.delete
      res.should =~ /does not exist/i
    end
    
  end

end