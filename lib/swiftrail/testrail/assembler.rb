require 'swiftrail/testrail/errors'
require 'swiftrail/testrail/api/test_case_result'
require 'swiftrail/testrail/intermediate_result'

module Swiftrail
  module Testrail
    class Assembler
      def initialize(swift_tests, junit_test_suites)
        @swift_tests = swift_tests
        @junit_test_suites = junit_test_suites
      end

      def assemble
        intermediate_results.group_by(&:case_id).map do |k, v|
          Api::TestCaseResult.from(k, v)
        end
      end

      private

      attr_reader :swift_tests, :junit_test_suites

      def intermediate_results
        junit_test_suites.map(&method(:test_cases)).flatten
      end

      def test_cases(test_suite)
        test_suite.test_cases.map do |test_case|
          swift_test = swift_test_for(test_case)
          if swift_test.nil?
            []
          else
            swift_test.case_ids.map do |case_id|
              IntermediateResult.new(swift_test.file_name, swift_test.class_name, swift_test.test_name, test_case.success?, test_case.duration, test_case.failures, case_id)
            end
          end
        end
      end

      def swift_test_for(junit_test_case)
        tests = swift_tests.select do |test|
          test.class_name == junit_test_case.class_name &&
            test.test_name == junit_test_case.test_name
        end
        raise Error::Ambiguity.new(junit_test_case, tests) if tests.count > 1

        tests.first
      end
    end
  end
end
