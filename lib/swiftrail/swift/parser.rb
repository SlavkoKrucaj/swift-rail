require 'swiftrail/swift/test'

module Swiftrail
  module Swift
    class Parser
      def initialize(test_patterns)
        @test_patterns = test_patterns
      end

      def parse
        all_files.map do |file_name|
          collect_test_cases(file_name, IO.read(file_name))
        end.flatten
      end

      private

      attr_reader :test_patterns
      RegexMatch = Struct.new(:case_ids, :class_type?, :name)

      def all_files
        test_patterns.map do |test_pattern|
          Dir[test_pattern]
        end.flatten.uniq
      end

      # @return [Test]
      def collect_test_cases(file_name, content)
        class_cases = []
        class_name = ''
        content.scan(cases_regex).map { |match|
          RegexMatch.new(sanitize(match[1]), match[2] == 'class ', match[3])
        }.reduce([]) { |result, match|
          if match.class_type?
            class_cases = match.case_ids
            class_name = match.name
          else
            result << Test.new(file_name, class_name, match.name, (match.case_ids + class_cases).uniq)
          end
          result
        }
      end

      def cases_regex
        %r{(//\s*TESTRAIL\s*([(C(0-9)*)|\s|,]*)$\s*)*(func |class )\s*(\w*)\s*(\(\)|:\s*XCTestCase)}im
      end

      def sanitize(case_ids)
        return [] if case_ids.nil? || case_ids.empty?

        case_ids.delete(' ')
                .split(',')
                .select { |case_id| case_id.downcase.start_with?('c') }
                .map { |case_id| case_id[1..-1] }
      end
    end
  end
end
