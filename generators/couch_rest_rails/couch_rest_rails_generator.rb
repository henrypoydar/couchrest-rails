class CouchRestRailsGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      
      m.directory "db/couch/fixtures"
      m.directory "db/couch/views"
            
      m.template "couchdb.yml", "config/couchdb.yml"
      m.template "couchdb_initializer.rb", "config/initializers/couchdb.rb"
    
    end
  end
end
