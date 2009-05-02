couchdb_config = YAML.load_file(File.join(Rails.root, %w[config couchdb.yml]))
 
ENV['RAILS_ENV'] = "development" if ENV['RAILS_ENV'] == nil
 
host      = couchdb_config[ENV['RAILS_ENV']]["host"]
port      = couchdb_config[ENV['RAILS_ENV']]["port"]
database  = couchdb_config[ENV['RAILS_ENV']]["database"]

host     = "localhost"  if host == nil
port     = "5984"       if port == nil
 
Rails.logger.error("No database specified in config/couchdb.yml")  if database == nil

COUCHDB_SERVER = {:host => host, :port => port, :database => database}