module Swiftrail
  module Swift
    Test = Struct.new(:file_name, :class_name, :test_name, :case_ids) do
      def to_json(*args)
        {
          file_name: file_name,
          class_name: class_name,
          test_name: test_name,
          case_ids: case_ids
        }
      end
    end
  end
end
