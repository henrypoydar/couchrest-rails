begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base application"
  exit
end

module ResetFooBarClasses
  # Reset document models
  class CouchRestRailsTestDocumentFoo < NilClass; end
  class CouchRestRailsTestDocumentBar < NilClass; end
  class CouchRestRailsTestDocumentNoDatabase < NilClass; end
end


def setup_foo_bars
  include ResetFooBarClasses
  
  # Config
  CouchRestRails.use_lucene = true
  CouchRestRails.views_path = 'vendor/plugins/couchrest-rails/spec/mock/couch'
  CouchRestRails.fixtures_path = 'vendor/plugins/couchrest-rails/spec/mock/fixtures'
  CouchRestRails.lucene_path = 'vendor/plugins/couchrest-rails/spec/mock/couch'
  
  # Paths
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
  
  # Delete existing
  CouchRest.delete(@foo_db_url) rescue nil
  CouchRest.delete(@bar_db_url) rescue nil
  
end

def cleanup_foo_bars
  CouchRest.delete(@foo_db_url) rescue nil
  CouchRest.delete(@bar_db_url) rescue nil
  ['foo', 'bar', 'foox', 'barx'].each do |db|
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.views_path, db))
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.lucene_path, db))
  end
end