module CouchRestRails
  module Tests

    extend self

    def setup(database="*")
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails::Database.delete(database)
      CouchRestRails::Database.create(database)
      CouchRestRails::Fixtures.load(database)
    end

    def teardown(database="*")
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails::Database.delete(database)
    end
  end
end
