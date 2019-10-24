require 'swiftrail/swift/parser'

module Swiftrail
  module Swift
    class Lint
        def initialize(tests_patterns)
          @tests_patterns = tests_patterns
        end
  
        def lint
          swift_tests.select { |t| t.case_ids.empty? }
        end
  
        private
  
        attr_reader :tests_patterns, :test_rail_username, :test_rail_password, :test_rail_base_url
  
        def swift_tests
          swift_test_parser.parse
        end
  
        def swift_test_parser
          Swiftrail::Swift::Parser.new(tests_patterns)
        end
    end  
  end
end
