require File.dirname(__FILE__) + '/../../spec_helper'

describe CouchRestRails::Document do
  
  class CouchRestRailsTestDocument < CouchRestRails::Document 
    
  end
  
  before :each do
    @doc = CouchRestRailsTestDocument.new
  end
  
  it "should inherit from CouchRest::ExtendedDocument" do
    CouchRestRails::Document.ancestors.include?(CouchRest::ExtendedDocument).should be_true
  end
  
  it "should use the COUCHDB_SERVER constant to define its CouchDB connection" do
    @doc.database.name.should == COUCHDB_CONFIG[:database]
  end

  
end