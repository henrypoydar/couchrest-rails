require File.dirname(__FILE__) + '/../spec_helper'

describe Spec::Rails::Matchers do
  
  describe 'validations' do
    
    before :all do
      class CouchFoo < CouchRestRails::Document  
        
        property  :question
        property  :answer
        
        validates_present :question
      
      end
      @couch_foo = CouchFoo.new
    end
    
    it "should have a matcher for validates_present" do
      @couch_foo.should validate_present(:question)
    end
    
  end
  
end