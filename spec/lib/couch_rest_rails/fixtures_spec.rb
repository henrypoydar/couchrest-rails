require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Fixtures do
  
  before :each do
    CouchRestRails.use_lucene = false
    CouchRestRails.views_path = 'vendor/plugins/couchrest-rails/spec/mock/couch'
    CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
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
  end
  
  
  describe '#blurbs' do
    
    it 'should produce an array of text blurbs for testing purposes' do
      CouchRestRails::Fixtures.blurbs.is_a?(Array).should be_true
    end
  
    it 'should produce a random text blurb' do
      CouchRestRails::Fixtures.random_blurb.is_a?(String).should be_true
    end
  
  end

  describe '#load' do
  
    after :each do
      CouchRestRails::Database.delete('foo')
      CouchRestRails::Database.delete('bar')
      cleanup_view_paths
    end
    
    it "should notify if the specified database doesn't exist" do
      res = CouchRestRails::Fixtures.load('foo')
      res.should =~ /does not exist/i
    end

    it "should load up the Yaml files in CouchRestRails.fixtures_path as documents for the specified database" do
      CouchRestRails::Database.create('foo')
      res = CouchRestRails::Fixtures.load('foo')
      db = CouchRest.database(@foo_db_url)
      db.documents['rows'].size.should == 10
    end
  
    it "should load up the Yaml files in CouchRestRails.fixtures_path as documents for all databases if no argument is passed" do
      class CouchRestRailsTestDocumentFoo < CouchRestRails::Document 
        use_database :foo
      end 
      class CouchRestRailsTestDocumentBar < CouchRestRails::Document 
        use_database :bar
      end
      CouchRestRails::Database.create('foo')
      CouchRestRails::Database.create('bar')
      CouchRestRails::Fixtures.load
      db_foo = CouchRest.database(@foo_db_url)
      db_bar = CouchRest.database(@bar_db_url)
      (db_foo.documents['rows'].size + db_bar.documents['rows'].size).should == 15
    end
  
  end
  
  describe "#dump" do
    
  end

end
