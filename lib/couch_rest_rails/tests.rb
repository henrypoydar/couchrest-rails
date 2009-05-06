module CouchRestRails
  module Tests
  
    extend self
  
    def setup
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails.drop
      CouchRestRails.create
      CouchRestRails::Fixtures.load
    end
    
    def teardown
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails.drop
    end
  
  end
end