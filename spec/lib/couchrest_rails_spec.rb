require File.dirname(__FILE__) + '/../spec_helper'
require 'rails_generator'
require 'rails_generator/scripts/generate'

describe 'CouchrestRails' do

  describe 'plugin installation' do
    
    before :all do
      @fake_rails_root = File.join(File.dirname(__FILE__), 'rails_root')
      FileUtils.mkdir_p(@fake_rails_root)
      FileUtils.mkdir_p("#{@fake_rails_root}/config/initializers")
    end
    
    after :all do
      FileUtils.rm_rf(@fake_rails_root)
    end
    
    it "should generate the necessary files in the host application" do
      Rails::Generator::Scripts::Generate.new.run(
        ['couchrest_rails', 'relax'], :destination => @fake_rails_root)
      Dir.glob(File.join(@fake_rails_root, "**", "*.*")).map {|f| File.basename(f)}.should == 
        ['couchdb.yml', 'couchdb.rb']
    end
    
  end
  
end