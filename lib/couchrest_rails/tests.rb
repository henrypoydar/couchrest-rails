module CouchrestRails
  module Tests
    
    extend self;
  
    def setup
      ENV['RAILS_ENV'] = CouchrestRails.test_environment
      CouchrestRails.drop
      CouchrestRails.create
      CouchrestRails::Fixtures.load(ENV['FIXTURES_PATH'])
    end
    
    def teardown
      ENV['RAILS_ENV'] = CouchrestRails.test_environment
      CouchrestRails.drop
    end
  
  end
end