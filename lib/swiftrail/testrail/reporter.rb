require 'swiftrail/junit/parser'
require 'swiftrail/swift/parser'
require 'swiftrail/testrail/assembler'
require 'swiftrail/testrail/api/client'

module Swiftrail
  module Testrail
    class Reporter
      def initialize(test_report_patterns, tests_patterns, test_rail_username, test_rail_password, test_rail_base_url, strict)
        @test_report_patterns = test_report_patterns
        @tests_patterns = tests_patterns
        @test_rail_username = test_rail_username
        @test_rail_password = test_rail_password
        @test_rail_base_url = test_rail_base_url
        @strict = strict
      end

      def report_results(run_id, dry_run)
        unless dry_run
          test_rail_client(run_id).publish_results(purge(assembler(swift_test_parser.parse, junit_parser.parse).assemble, run_id))
        else
          STDOUT::puts("RUN_ID = #{run_id}")
          STDOUT::puts(purge(assembler(swift_test_parser.parse, junit_parser.parse).assemble, run_id).map(&:to_json))
        end
      end

      private

      attr_reader :test_report_patterns, :tests_patterns, :test_rail_username, :test_rail_password, :test_rail_base_url, :strict

      def assembler(swift_tests, junit_test_suites)
        Assembler.new(swift_tests, junit_test_suites)
      end

      def purge(test_cases, run_id)
        test_cases.select do |test_case|
          !strict || test_rail_test_cases(run_id).include?(test_case.case_id)
        end
      end

      def swift_test_parser
        Swiftrail::Swift::Parser.new(tests_patterns)
      end

      def junit_parser
        Swiftrail::Junit::Parser.new(test_report_patterns)
      end

      def test_rail_test_cases(run_id)
        @test_cases ||= test_rail_client(run_id).all_tests.map(&:case_id).map(&:to_s)
      end

      def test_rail_client(run_id)
        Api::Client.new(test_rail_base_url, test_rail_username, test_rail_password, run_id)
      end

    end
  end
end
