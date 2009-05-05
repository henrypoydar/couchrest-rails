namespace :couchdb do
  
  desc "Create the CouchDB database defined in config/couchdb.yml for the current environment"
  task :create => :environment do
    CouchrestRails.create
  end
  
  desc "Drops the couchdb database for the current RAILS_ENV"
  task :drop => :environment do
    CouchrestRails.drop
  end
  
  desc "Drops and recreates the CouchDB database for the current RAILS_ENV"
  task :reset => [:drop, :create]
  
  namespace :test do
    desc "Empty the test couchdb database"
    task :reset do
      `rake RAILS_ENV=test couchdb:drop`
      `rake RAILS_ENV=test couchdb:create`
    end
  end
  
  namespace :fixtures do
    desc "Load fixtures into the current environment's CouchDB database"
    task :load => :environment do
      CouchrestRails::Fixtures.load
    end
  end
  
end
