module CouchRestRails
  class Document < CouchRest::ExtendedDocument
    use_database COUCHDB_SERVER.default_database
      
    
  end
end