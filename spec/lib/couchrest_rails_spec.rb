require File.dirname(__FILE__) + '/../spec_helper'
require 'rails_generator'
require 'rails_generator/scripts/generate'

describe 'CouchrestRails' do
  
  after :all do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
  end
  
  describe 'plugin installation' do
    
    before :all do
      @fake_rails_root = File.join(File.dirname(__FILE__), 'rails_root')
      FileUtils.mkdir_p(@fake_rails_root)
      FileUtils.mkdir_p("#{@fake_rails_root}/config/initializers")
    end
    
    after :all do
      FileUtils.rm_rf(@fake_rails_root)
    end
    
    it "should generate the necessary files in the host application" do
      Rails::Generator::Scripts::Generate.new.run(
        ['couchrest_rails', 'relax'], :destination => @fake_rails_root)
      Dir.glob(File.join(@fake_rails_root, "**", "*.*")).map {|f| File.basename(f)}.should == 
        ['couchdb.yml', 'couchdb.rb']
    end
    
  end
  
  describe '#create' do

    before :each do
      CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
    end
    
    it 'should create a couchdb database for the current environment' do
      CouchrestRails.create
      res = CouchRest.get(COUCHDB_SERVER[:instance])
      res['db_name'].should == COUCHDB_SERVER[:database]
    end

    it 'should do nothing and display a message if the database already exists' do
      CouchRest.database!("#{COUCHDB_SERVER[:instance]}")
      res = CouchrestRails.create
      res.should =~ /already exists/i
    end

  end
  
end
  
describe 'CouchrestRails::Fixtures' do
  
  after :all do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
  end
    
  describe '#blurbs' do
    
    it 'should produce an array of text blurbs for testing purposes' do
      CouchrestRails::Fixtures.blurbs.is_a?(Array).should be_true
    end
  
    it 'should produce a random text blurb' do
      CouchrestRails::Fixtures.random_blurb.is_a?(String).should be_true
    end
  
  end

  describe '#load' do
  
    before :each do
      CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
    end
  
    it "should exit if the database doesn't exist" do
      res = CouchrestRails::Fixtures.load
      res.should =~ /does not exist/i
    end

    it 'should load up the yaml files in <RAILS_ROOT>/db/couchdb/fixtures' do
      db = CouchRest.database!(COUCHDB_SERVER[:instance])
      CouchrestRails::Fixtures.load('vendor/plugins/couchrest-rails/spec/fixtures/couchdb')
      db.documents['rows'].size.should == 10
    end
  
  end

end

describe 'CouchrestRails::Tests' do
  
  after :all do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
  end
  
  before :each do
    CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
    ENV['FIXTURES_PATH'] = 'vendor/plugins/couchrest-rails/spec/fixtures/couchdb'
  end
  
  describe '#setup' do
    
    it 'should drop, add and load fixtures for the test database' do
      CouchrestRails.create
      db = CouchRest.database(COUCHDB_SERVER[:instance])
      CouchrestRails::Fixtures.load(ENV['FIXTURES_PATH'])
      db.documents['rows'].size.should == 10
      CouchrestRails::Tests.setup
      db.documents['rows'].size.should == 10
    end
    
  end
  
  describe '#teardown' do
    
    it 'should drop the test database' do
      CouchrestRails::Tests.setup
      db = CouchRest.database(COUCHDB_SERVER[:instance])
      db.documents['rows'].size.should == 10
      CouchrestRails::Tests.teardown
      lambda {CouchRest.get(COUCHDB_SERVER[:instance])}.should raise_error('Resource not found')
    end
    
  end
    
end
