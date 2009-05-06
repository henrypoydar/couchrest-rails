namespace :couchdb do
  
  desc "Create the CouchDB database defined in config/couchdb.yml for the current environment"
  task :create => :environment do
    puts CouchRestRails.create
  end
  
  desc "Drops the couchdb database for the current RAILS_ENV"
  task :drop => :environment do
    puts CouchRestRails.drop
  end
  
  desc "Drops and recreates the CouchDB database for the current RAILS_ENV"
  task :reset => [:drop, :create]
  
  namespace :test do
    desc "Empty the test CouchDB database"
    task :reset do
      `rake RAILS_ENV=test couchdb:drop`
      `rake RAILS_ENV=test couchdb:create`
    end
  end
  
  namespace :fixtures do
    desc "Load fixtures into the current environment's CouchDB database"
    task :load => :environment do
      puts CouchRestRails::Fixtures.load
    end
  end
  
  namespace :views do
    desc "Push views into the current environment's CouchDB database"
    task :push => :environment do
      puts CouchRestRails::Views.push
    end
  end
  
end
