require 'nokogiri'
require 'swiftrail/junit/report'

module Swiftrail
  module Junit
    class Parser
      def initialize(junit_patterns)
        @junit_patterns = junit_patterns
      end

      def parse
        all_files.map(&method(:test_suites)).flatten
      end

      private

      attr_reader :junit_patterns

      def all_files
        junit_patterns.map do |junit_pattern|
          Dir[junit_pattern]
        end.flatten.uniq
      end

      def test_suites(file)
        read_report(file).xpath('//testsuite').map(&method(:create_test_suite))
      end

      def read_report(file)
        Nokogiri::XML(IO.read(file))
      end

      def create_test_suite(test_suite)
        TestSuite.new(
          test_suite[:name],
          test_cases(test_suite)
        )
      end

      def test_cases(test_suite)
        test_suite.xpath('.//testcase').map do |test_case|
          TestCase.new(
            test_case[:classname],
            test_case[:classname].split('.').last,
            test_case[:name],
            failures(test_case),
            test_case[:time].to_f
          )
        end
      end

      def failures(test_case)
        test_case.children.select { |child| child.name == 'failure' }.map { |failure| failure.content }
      end
    end
  end
end
