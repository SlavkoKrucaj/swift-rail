require 'swiftrail/testrail/intermediate_result'

module Swiftrail
  module QuickNimble
    class Parser

      RegexMatch = Struct.new(:case_ids, :test_name)

      # return RegexMatch result
      def extractInformation(test_name)
        extracted_cases = test_name.scan(case_regex)[0]
        if !extracted_cases.nil?
          case_ids = extracted_cases.split('_').reject { |c| c.empty? }
          RegexMatch.new(case_ids, test_name)
        else
          RegexMatch.new([], test_name)
        end
      end

      # find all occurences in string like this example: "C12345"
      def case_regex
        %r{_(?:_(?:C\d+)+)+__}i
      end
    end
  end
end