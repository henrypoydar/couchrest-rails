module CouchRestRails

  mattr_accessor :test_environment
  self.test_environment = 'test'
  
  mattr_accessor :fixtures_path
  self.fixtures_path = 'db/couch/fixtures'
  
  mattr_accessor :views_path
  self.views_path = 'db/couch/views'
  
end
