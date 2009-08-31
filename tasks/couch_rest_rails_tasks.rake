namespace :couchdb do

  desc "Create the CouchDB database defined in config/couchdb.yml for the current environment"
  task :create, :database, :needs => :environment do |t, args|
    args.with_defaults(:database => "*", :opts => {})
    puts CouchRestRails::Database.create(args.database, args.opts)
  end

  desc "Deletes the CouchDB database for the current RAILS_ENV"
  task :delete, :database, :needs => :environment do |t, args|
    args.with_defaults(:database => "*", :opts => {})
    puts CouchRestRails::Database.delete(args.database, args.opts)
  end

  desc "Deletes and recreates the CouchDB database for the current RAILS_ENV"
  task :reset => [:delete, :create]

  namespace :test do
    desc "Empty the test CouchDB database"
    task :reset do
      `rake RAILS_ENV=test couchdb:delete`
      `rake RAILS_ENV=test couchdb:create`
    end
  end

  namespace :fixtures do
    desc "Load fixtures into the current environment's CouchDB database"
    task :load, :database, :needs  => :environment do |t, args|
      args.with_defaults(:database => "*")
      puts CouchRestRails::Fixtures.load(args.database)
    end
    task :dump, :database, :needs => :environment do |t, args|
      args.with_defaults(:database => "*")
      puts CouchRestRails::Fixtures.dump(args.database)
    end
  end

  namespace :views do
    desc "Push views into the current environment's CouchDB database"
    task :push, :database, :needs => :environment do |t, args|
      args.with_defaults(:database => "*", :opts => {})
      puts CouchRestRails::Views.push(args.database, args.opts)
    end
  end

  namespace :lucene do
    desc "Push views into the current environment's CouchDB database"
    task :push, :database, :needs => :environment do |t, args|
      args.with_defaults(:database => "*", :opts => {})
      puts CouchRestRails::Lucene.push(args.database, args.opts)
    end
  end

end
