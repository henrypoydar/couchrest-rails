module Spec
  module Rails
    module Matchers
      
      def validate_present(attribute)
        return simple_matcher("model to validate_present :#{attribute}") do |model|
          model.send("#{attribute}=", nil)
          !model.valid? && model.errors[attribute]
        end
      end
      
    end
  end
end