namespace :couchdb do
  
  desc "Create the CouchDB database defined in config/couchdb.yml for the current environment"
  task :create => :environment do
    CouchRest.database!("http://#{COUCHDB_SERVER[:host]}:#{COUCHDB_SERVER[:port]}/#{COUCHDB_SERVER[:database]}")
  end
  
  
  desc "Drops the couchdb database for the current RAILS_ENV"
  task :drop => :environment do
    cr = CouchRest.new("http://#{COUCHDB_SERVER[:host]}:#{COUCHDB_SERVER[:port]}")
    db = cr.database("#{COUCHDB_SERVER[:database]}")
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
