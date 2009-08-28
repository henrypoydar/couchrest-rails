begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base application"
  exit
end

def cleanup_view_paths
  ['foo', 'bar', 'foox', 'barx'].each do |db|
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.views_path, db))
    FileUtils.rm_rf(File.join(RAILS_ROOT, CouchRestRails.lucene_path, db))
  end
end