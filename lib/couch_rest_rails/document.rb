module CouchRestRails
  class Document < CouchRest::ExtendedDocument
    use_database CouchRest.database(COUCHDB_SERVER[:instance])
    
    
  end
end
  