namespace :couchdb do
  
  desc "Create the CouchDB database defined in config/couchdb.yml for the current environment"
  task :create => :environment do
    res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
    if res && res['db_name'] && res['db_name'] == COUCHDB_SERVER[:database]
      puts "The CouchDB database '#{COUCHDB_SERVER[:database]}' already exists"
    else
      CouchRest.database! COUCHDB_SERVER[:instance]
      puts "Created CouchDB database '#{COUCHDB_SERVER[:database]}'"
    end
  end
  
  desc "Drops the couchdb database for the current RAILS_ENV"
  task :drop => :environment do
    res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
    if res && res['db_name'] && res['db_name'] == COUCHDB_SERVER[:database]
      CouchRest.delete COUCHDB_SERVER[:instance]
      puts "Dropped CouchDB database '#{COUCHDB_SERVER[:database]}'"
    else
      puts "The CouchDB database '#{COUCHDB_SERVER[:database]}' does not exist"
    end  
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
      
      res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
      unless (res && res['db_name'] && res['db_name'] == COUCHDB_SERVER[:database])
        puts "The CouchDB database '#{COUCHDB_SERVER[:database]}' does not exist"
        exit
      end      
      
      db = CouchRest.database!(COUCHDB_SERVER[:instance])
      
      fixtures_path = ENV['FIXTURES_PATH'] || 'db/couch/fixtures'
      Dir.glob(File.join(RAILS_ROOT, fixtures_path, "**", "*.yml")).each do |file|
        db.bulk_save(YAML::load(ERB.new(IO.read(file)).result).map {|f| f[1]})
        puts "Added documents in '#{File.basename(file)}' to CouchDB database '#{COUCHDB_SERVER[:database]}'"
      end
    
    end
  end
  
end
