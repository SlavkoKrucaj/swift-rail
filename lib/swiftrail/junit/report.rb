module Swiftrail
  module Junit
    TestSuite = Struct.new(:suite_name, :test_cases)
    TestCase = Struct.new(:full_class_name, :class_name, :test_name, :failures, :duration) do
      def success?
        failures.empty?
      end
    end
  end
end
