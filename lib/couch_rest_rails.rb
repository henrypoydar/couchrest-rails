module CouchRestRails

  mattr_accessor :test_environment
  self.test_environment = 'test'

  mattr_accessor :setup_path
  self.setup_path = 'db/couch'

  mattr_accessor :fixture_path
  self.fixture_path = 'test/fixtures/couch'

end
