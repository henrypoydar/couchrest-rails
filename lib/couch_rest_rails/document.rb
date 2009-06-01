module CouchRestRails
  class Document < CouchRest::ExtendedDocument

    include Validatable

     def self.use_database(db)
       db = COUCHDB_CONFIG[:db_prefix] + db + COUCHDB_CONFIG[:db_suffix]
       # add prefix and suffix to db
       self.database = COUCHDB_SERVER.database(db)
     end
  end
end
