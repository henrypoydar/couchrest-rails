require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Document do
  
  class CouchRestRailsTestDocument < CouchRestRails::Document 
    use_database :foo
  end
  
  before :each do
    @doc = CouchRestRailsTestDocument.new
  end
  
  it "should inherit from CouchRest::ExtendedDocument" do
    CouchRestRails::Document.ancestors.include?(CouchRest::ExtendedDocument).should be_true
  end
  
  it "should define its CouchDB connection and CouchDB database name" do
    @doc.database.name.should == "#{COUCHDB_CONFIG[:db_prefix]}foo#{COUCHDB_CONFIG[:db_suffix]}"
  end

  
end