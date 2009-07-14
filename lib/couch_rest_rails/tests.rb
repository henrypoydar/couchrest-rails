module CouchRestRails
  module Tests

    extend self
    mattr_accessor :fixtures_loaded
    self.fixtures_loaded = Set.new

    def setup(database="*")
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      unless fixtures_loaded.include?(database)
        CouchRestRails::Database.delete(database)
        CouchRestRails::Database.create(database)
        CouchRestRails::Fixtures.load(database)
        fixtures_loaded << database
      end
    end

    def reset_fixtures
      CouchRestRails::Database.delete("*") unless fixtures_loaded.empty?
      fixtures_loaded.clear
    end

    def teardown(database="*")
      ENV['RAILS_ENV'] = CouchRestRails.test_environment
      CouchRestRails::Database.delete(database)
      CouchRestRails::Database.create(database)
      fixtures_loaded.delete(database)
    end
  end
end
module Test
  module Unit #:nodoc:
    class TestCase #:nodoc:
      setup :setup_couchdb_fixtures
      teardown :teardown_couchdb_fixtures

      superclass_delegating_accessor :database
      self.database = nil

      class << self
        def couchdb_fixtures(*databases)
          self.database = databases.map { |d| d.to_s }
        end
      end
      def setup_couchdb_fixtures
        CouchRestRails::Tests.setup(self.database) unless self.database.nil?
      end
      def teardown_couchdb_fixtures
        CouchRestRails::Tests.teardown(self.database) unless self.database.nil?
      end
    end
  end
end
