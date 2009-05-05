module CouchrestRails
  module Views
  
    extend self

    def push(views_path = ENV['VIEWS_PATH'])
        
      fixtures_path ||= 'db/couch'
      
      res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
      if res && res['db_name'] && res['db_name'] == COUCHDB_SERVER[:database]
        `couchapp push #{RAILS_ROOT}/#{views_path} #{COUCHDB_SERVER[:instance]}`
        return "Pushed views to CouchDB database '#{COUCHDB_SERVER[:database]}'"
      else
        return "CouchDB database '#{COUCHDB_SERVER[:database]}' doesn't exist"
      end
      
    end

  end
end