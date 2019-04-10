require 'swiftrail/swift/parser'

module Swiftrail
  module Testrail
    class Coverage
      def initialize(tests_patterns, test_rail_username, test_rail_password, test_rail_base_url)
        @tests_patterns = tests_patterns
        @test_rail_username = test_rail_username
        @test_rail_password = test_rail_password
        @test_rail_base_url = test_rail_base_url
      end

      def coverage_report(run_id)
        coverage_results = test_rail_client(run_id).all_tests.each_with_object({}) do |test, hash|
          hash[test] = swift_tests_for_case_id(test.case_id)
        end
        generate_report(coverage_results)
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

      # @return json
      def generate_report(results)
        {
          coverage: {
            covered: results.values.reject { |value| value.nil? || value.empty? }.count.to_f,
            total_test_cases: results.keys.count.to_f,
            percentage: results.values.reject { |value| value.nil? || value.empty? }.count.to_f / results.keys.count.to_f
          },
          metadata: results.map do |test_rail_test, swift_tests|
                      {
                        test_rail: test_rail_test.to_json,
                        covered_by: [
                          swift_tests.map(&:to_json)
                        ]
                      }
                    end
        }
      end

      def swift_tests
        @swift_tests ||= swift_test_parser.parse
      end

      def swift_test_parser
        Swiftrail::Swift::Parser.new(tests_patterns)
      end
    end
  end
end
