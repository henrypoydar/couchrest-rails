require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Database do

  before :each do
    CouchRestRails.use_lucene = true
    CouchRestRails.views_path = 'vendor/plugins/couchrest-rails/spec/mock/couch'
    CouchRestRails.lucene_path = 'vendor/plugins/couchrest-rails/spec/mock/couch'
    @foo_db_name = [
      COUCHDB_CONFIG[:db_prefix], 'foo',
      COUCHDB_CONFIG[:db_suffix]
    ].join
    @foo_db_url = [
      COUCHDB_CONFIG[:host_path], "/",
      @foo_db_name 
    ].join
    @bar_db_name = @foo_db_name.gsub(/foo/, 'bar')
    @bar_db_url = @foo_db_url.gsub(/foo/, 'bar')
    CouchRest.delete(@foo_db_url) rescue nil
    CouchRest.delete(@bar_db_url) rescue nil
  end
  
  after :all do
    CouchRest.delete(@foo_db_url) rescue nil
    CouchRest.delete(@bar_db_url) rescue nil
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.views_path, 'foo'))
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.views_path, 'bar'))
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.lucene_path, 'foo'))
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.lucene_path, 'bar'))
  end
  
  describe '#create' do
  
    it 'should create the specified CouchDB database for the current environment' do
      CouchRestRails::Database.create('foo')
      res = CouchRest.get(@foo_db_url)
      res['db_name'].should == @foo_db_name
    end

    it 'should do nothing and display a message if the database already exists' do
      CouchRest.database!(@foo_db_url)
      res = CouchRestRails::Database.create('foo')
      res.should =~ /already exists/i
    end
    
    it 'should create a folder to store database views' do
      res = CouchRestRails::Database.create('foo')
      File.exist?(File.join(RAILS_ROOT, CouchRestRails.views_path, 'foo', 'views')).should be_true
    end
    
    it 'should create a folder to store lucene design docs if Lucene is enabled' do
      res = CouchRestRails::Database.create('foo')
      File.exist?(File.join(RAILS_ROOT, CouchRestRails.lucene_path, 'foo', 'lucene')).should be_true
    end
    
    it 'should create all databases as defined in CouchRestRails::Document models when no argument is specified' do
      class CouchRestRailsTestDocumentFoo < CouchRestRails::Document 
        use_database :foo
      end 
      class CouchRestRailsTestDocumentBar < CouchRestRails::Document 
        use_database :bar
      end
      CouchRestRails::Database.create
      f = CouchRest.get(@foo_db_url)
      f['db_name'].should == @foo_db_name
      b = CouchRest.get(@bar_db_url)
      b['db_name'].should == @bar_db_name
    end
    
    it 'should issue a warning if no CouchRestRails::Document models are using the database' do
      res = CouchRestRails::Database.create('foobar')
      res.should =~ /no CouchRestRails::Document models using/
      CouchRestRails::Database.delete('foobar')
      FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.views_path, 'foobar'))
    end

  end
  
  describe "#delete" do
    
    it 'should delete the specified CouchDB database for the current environment' do
      CouchRest.database!(@foo_db_url)
      CouchRestRails::Database.delete('foo')
      lambda {CouchRest.get(@foo_db_url)}.should raise_error('Resource not found')
    end

    it 'should do nothing and display a message if the database does not exist' do
      res = CouchRestRails::Database.delete('foo')
      res.should =~ /does not exist/i
    end
    
    it 'should delete all databases as defined in CouchRestRails::Document models when no argument is specified' do
      CouchRest.database!(@foo_db_url)
      CouchRest.database!(@bar_db_url)
      CouchRestRails::Database.delete
      lambda {CouchRest.get(@foo_db_url)}.should raise_error('Resource not found')
      lambda {CouchRest.get(@bar_db_url)}.should raise_error('Resource not found')
    end
    
    it 'should warn if the views path for the database still exists' do
      CouchRestRails::Database.create('foo')
      res = CouchRestRails::Database.delete('foo')
      res.should =~ /views path still present/
    end
    
    it 'should warn if the Lucene path for the database still exists if Lucene is enabled' do
      CouchRestRails::Database.create('foo')
      res = CouchRestRails::Database.delete('foo')
      res.should =~ /Lucene path still present/
    end
    
  end
  
  describe '#list' do

    it 'should return a sorted array of all CouchDB databases for the application' do
      class CouchRestRailsTestDocumentFoo < CouchRestRails::Document 
        use_database :foo
      end 
      class CouchRestRailsTestDocumentBar < CouchRestRails::Document 
        use_database :bar
      end
      CouchRestRails::Database.list.include?('bar').should be_true
      CouchRestRails::Database.list.include?('foo').should be_true
      CouchRestRails::Database.list.index('foo').should > CouchRestRails::Database.list.index('bar')
    end

    it 'should raise an error if a model does not have a database defined' do
      class CouchRestRailsTestDocumentNoDatabase < CouchRestRails::Document 
      end
      lambda {CouchRestRails::Database.list}.should raise_error('CouchRestRailsTestDocumentNoDatabase does not have a database defined')
    end

  end

end