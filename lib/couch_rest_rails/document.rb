module CouchRestRails
  class Document < CouchRest::ExtendedDocument
    use_database COUCHDB_SERVER.default_database
    include CouchRest::Validation
    
  end
end