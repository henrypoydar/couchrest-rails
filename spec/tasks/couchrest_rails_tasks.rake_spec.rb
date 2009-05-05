require File.dirname(__FILE__) + '/../spec_helper'

describe 'rake tasks' do
  
  before :each do
    CouchRest.new("#{COUCHDB_SERVER[:host]}").database("#{COUCHDB_SERVER[:database]}").delete! rescue nil
  end
  
  after :all do
    CouchRest.new("#{COUCHDB_SERVER[:host]}").database("#{COUCHDB_SERVER[:database]}").delete! rescue nil
  end
  
  describe 'couchdb:create' do
    
    it 'should create a couchdb database for the current environment' do
      `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} rake couchdb:create`
      res = CouchRest.get(COUCHDB_SERVER[:instance])
      res['db_name'].should == COUCHDB_SERVER[:database]
    end
    
    it 'should do nothing and display a message if the database already exists' do
      CouchRest.database!("#{COUCHDB_SERVER[:instance]}")
      res = `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} rake couchdb:create`
      res.should =~ /already exists/i
    end
  
  end
  
  describe 'couchdb:drop' do
    
    it 'should delete the couchdb database' do
      CouchRest.database!("#{COUCHDB_SERVER[:instance]}")
      `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} rake couchdb:drop`
      res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
      res.should be_nil
    end
    
    it 'should do nothing and display a message if the database does not exist' do
      res = `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} rake couchdb:drop`
      res.should =~ /does not exist/i
    end
    
  end
  
  describe 'couchdb:reset' do
    
    it 'should drop and add the database' do
      `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} rake couchdb:reset`
      res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
      res['db_name'].should == COUCHDB_SERVER[:database]
    end
    
  end
  
  describe 'couchdb:test:reset' do
    
    it 'should drop and add the database for the test environment only' do
      `cd #{RAILS_ROOT}; RAILS_ENV=development rake couchdb:test:reset`
      res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
      res['db_name'].should == COUCHDB_SERVER[:database]
    end
    
  end
  
  describe 'couchdb:fixtures:load' do
    
    it "should exit if the database doesn't exist" do
      res = `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} rake couchdb:fixtures:load`
      res.should =~ /does not exist/i
    end
    
    it 'should attempt to load up the Yaml files in <RAILS_ROOT>/db/couchdb/fixtures' do
      `cd #{RAILS_ROOT}; RAILS_ENV=#{ENV['RAILS_ENV']} FIXTURES_PATH=vendor/plugins/couchrest-rails/spec/fixtures/couchdb rake couchdb:fixtures:load`
      db = CouchRest.database(COUCHDB_SERVER[:instance])
      puts db.documents.inspect 
      db.documents.size.should == 9 
    end
    
  end
  
end