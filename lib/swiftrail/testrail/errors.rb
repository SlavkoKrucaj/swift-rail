require 'swiftrail/errors/error'

module Swiftrail
  module Testrail
    module Error
      class Ambiguity < Errors::Base
        def initialize(test_case, swift_tests)
          super("Test Case (#{test_case} from junit report, corresponds to multiple swift tests #{swift_tests}")
        end
      end
    end
  end
end
