require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Fixtures do
  
  describe '#blurbs' do
    
    it 'should produce an array of text blurbs for testing purposes' do
      CouchRestRails::Fixtures.blurbs.is_a?(Array).should be_true
    end
  
    it 'should produce a random text blurb' do
      CouchRestRails::Fixtures.random_blurb.is_a?(String).should be_true
    end
  
  end

  describe '#load' do
  
    before :each do
      CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
    end
    
    after :all do
      CouchRest.delete(COUCHDB_SERVER[:instance]) rescue nil
    end
  
    it "should exit if the database doesn't exist" do
      res = CouchRestRails::Fixtures.load
      res.should =~ /does not exist/i
    end

    it "should load up the yaml files in CouchRestRails.fixtures_path as documents" do
      db = CouchRest.database!(COUCHDB_SERVER[:instance])
      CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
      CouchRestRails::Fixtures.load
      db.documents['rows'].size.should == 10
    end
  
  end

end
