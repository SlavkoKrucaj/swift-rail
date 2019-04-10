require 'swiftrail/swift/parser'

module Swiftrail
  module Testrail
    class Lint
      def initialize(tests_patterns, test_rail_username, test_rail_password, test_rail_base_url)
        @tests_patterns = tests_patterns
        @test_rail_username = test_rail_username
        @test_rail_password = test_rail_password
        @test_rail_base_url = test_rail_base_url
      end

      def lint_report(run_id)
        missing_cases = all_tests_by_case_id.keys - test_rail_client(run_id).all_tests.map(&:case_id).map(&:to_s)
        generate_report(missing_cases)
      end

      private

      attr_reader :tests_patterns, :test_rail_username, :test_rail_password, :test_rail_base_url

      def swift_tests_for_case_id(case_id)
        swift_tests.select do |swift_test|
          swift_test.case_ids.include?(case_id.to_s)
        end
      end

      def test_rail_client(run_id)
        Swiftrail::Testrail::Api::Client.new(test_rail_base_url, test_rail_username, test_rail_password, run_id)
      end

      def generate_report(case_ids)
        {
          reporting_invalid_case_ids: case_ids.map do |case_id|
            { case_id => all_tests_by_case_id[case_id].map(&:to_json) }
          end
        }
      end

      def all_tests_by_case_id
        @all_tests_by_case_id ||= swift_tests.each_with_object({}) do |test, hash|
          test.case_ids.map do |case_id|
            if hash.key?(case_id)
              hash[case_id] << test
            else
              hash[case_id] = [test]
            end
          end
        end
      end

      def swift_tests
        swift_test_parser.parse
      end

      def swift_test_parser
        Swiftrail::Swift::Parser.new(tests_patterns)
      end
    end
  end
end
