module CouchRestRails
  module Tests
  
    extend self
  
    def setup
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails::Database.delete
      CouchRestRails::Database.create
      CouchRestRails::Views.push
      CouchRestRails::Fixtures.load
    end
    
    def teardown
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails::Database.delete
    end
  
  end
end