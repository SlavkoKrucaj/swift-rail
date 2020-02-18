require 'swiftrail/testrail/intermediate_result'

module Swiftrail
  module QuickNimble
    class Parser

      RegexMatch = Struct.new(:case_ids, :test_name)

      # return RegexMatch result
      def extract_information(test_name)
        RegexMatch.new(cases(test_name), test_name)
      end

      # find all occurences in string like this example: "C12345"
      def cases(test_name)
        test_name
          .split('__')
          .map { |group| group.split('_') }
          .select { |elements| elements.all? { |case_id| case_id =~ /C\d+/i } }
          .flatten
          .map { |case_id| case_id[1..-1] }
      end
    end
  end
end