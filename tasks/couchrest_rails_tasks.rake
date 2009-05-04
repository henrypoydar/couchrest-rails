require 'json'

namespace :couchdb do
  
  desc "Create the CouchDB database defined in config/couchdb.yml for the current environment"
  task :create => :environment do
    res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
    if res && res['db_name'] && res['db_name'] == COUCHDB_SERVER[:database]
      puts "The CouchDB database '#{COUCHDB_SERVER[:database]}' already exists"
    else
      CouchRest.database!(COUCHDB_SERVER[:instance])
    end
  end
  
  desc "Drops the couchdb database for the current RAILS_ENV"
  task :drop => :environment do
    cr = CouchRest.new(COUCHDB_SERVER[:host])
    db = cr.database(COUCHDB_SERVER[:database])
    db.delete! rescue nil
  end
  
  desc "Drops and recreates the couchdb database for the current RAILS_ENV"
  task :reset => [:drop, :create]
  
  namespace :test do
    desc "Empty the test couchdb database"
    task :reset do
      `rake RAILS_ENV=test couchdb:drop`
      `rake RAILS_ENV=test couchdb:create`
    end
  end
  
end
