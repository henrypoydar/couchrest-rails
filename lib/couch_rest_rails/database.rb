module CouchRestRails
  module Database
  
    extend self

    def create
      res = CouchRest.get(COUCHDB_CONFIG[:full_path]) rescue nil
      if res && res['db_name'] && res['db_name'] == COUCHDB_CONFIG[:database]
        return "The CouchDB database '#{COUCHDB_CONFIG[:database]}' already exists"
      else
        CouchRest.database! COUCHDB_CONFIG[:full_path]
        return "Created CouchDB database '#{COUCHDB_CONFIG[:database]}'"
      end
    end

    def delete
      res = CouchRest.get(COUCHDB_CONFIG[:full_path]) rescue nil
      if res && res['db_name'] && res['db_name'] == COUCHDB_CONFIG[:database]
        CouchRest.delete COUCHDB_CONFIG[:full_path]
        return "Dropped CouchDB database '#{COUCHDB_CONFIG[:database]}'"
      else
        return "The CouchDB database '#{COUCHDB_CONFIG[:database]}' does not exist"
      end
    end
    
  end
end