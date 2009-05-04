class CouchrestRailsGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.template "couchdb_initializer.rb", "config/initializers/couchdb.rb"
    end
  end
end
