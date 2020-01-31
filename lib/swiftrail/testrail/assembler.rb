require 'swiftrail/testrail/errors'
require 'swiftrail/testrail/api/test_case_result'
require 'swiftrail/testrail/intermediate_result'
require 'swiftrail/quicknimble/parser'

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
            search_cases_ids(test_case)
          else
            swift_test.case_ids.map do |case_id|
              IntermediateResult.new(swift_test.file_name, swift_test.class_name, swift_test.test_name, test_case.success?, test_case.duration, test_case.failures, case_id)
            end
          end
        end
      end

      # lookup case ids in test_case name
      def search_cases_ids(test_case)
        result = QuickNimble::Parser.new().extractInformation(test_case.test_name)
        if result.case_ids.empty?
          []
        else
          result.case_ids.map do |case_id|
            IntermediateResult.new(result.test_name, result.test_name, result.test_name, test_case.success?, test_case.duration, test_case.failures, case_id)
          end
        end
      end

      def swift_test_for(junit_test_case)
        tests = swift_tests.select do |test|
          test.class_name == junit_test_case.class_name &&
            test.test_name == junit_test_case.test_name
        end
        if tests.count > 1
          STDERR.puts(Error::Ambiguity.new(junit_test_case, tests))
          nil
        else 
          tests.first
        end
      end
    end
  end
end
