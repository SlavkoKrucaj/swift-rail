require 'swiftrail/junit/parser'
require 'swiftrail/swift/parser'
require 'swiftrail/testrail/assembler'
require 'swiftrail/testrail/api/client'

module Swiftrail
  module Testrail
    class Reporter
      def initialize(test_report_patterns, tests_patterns, test_rail_username, test_rail_password, test_rail_base_url)
        @test_report_patterns = test_report_patterns
        @tests_patterns = tests_patterns
        @test_rail_username = test_rail_username
        @test_rail_password = test_rail_password
        @test_rail_base_url = test_rail_base_url
      end

      def report_results(run_id)
        test_rail_client(run_id).publish_results(assembler(swift_test_parser.parse, junit_parser.parse).assemble)
      end

      private

      attr_reader :test_report_patterns, :tests_patterns, :test_rail_username, :test_rail_password, :test_rail_base_url

      def test_rail_client(run_id)
        Api::Client.new(test_rail_base_url, test_rail_username, test_rail_password, run_id)
      end

      def assembler(swift_tests, junit_test_suites)
        Assembler.new(swift_tests, junit_test_suites)
      end

      def swift_test_parser
        Swiftrail::Swift::Parser.new(tests_patterns)
      end

      def junit_parser
        Swiftrail::Junit::Parser.new(test_report_patterns)
      end
    end
  end
end
