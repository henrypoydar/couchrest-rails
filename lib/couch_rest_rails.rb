module CouchRestRails

  mattr_accessor :lucene_path
  self.lucene_path = 'db/couch'

  mattr_accessor :fixture_path
  self.fixture_path = 'test/fixtures/couch'
  
  mattr_accessor :test_environment
  self.test_environment = 'test'
  
  mattr_accessor :use_lucene
  self.use_lucene = false
  
  mattr_accessor :views_path
  self.views_path = 'db/couch'
  
end
