require File.dirname(__FILE__) + '/../spec_helper'
require 'net/http'
require 'json'

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
    
  end
  
  describe 'couchdb:reset' do
    
    it 'should drop and add the database' do
      
    end
    
  end
  
  describe 'couchdb:test:reset' do
    
    it 'should drop and the database for the test environment only' do
      
    end
    
  end
  
end
  

