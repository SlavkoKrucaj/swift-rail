module Swiftrail
  module Testrail
    IntermediateResult = Struct.new(:file_name, :class_name, :test_name, :success?, :duration, :failures, :case_id)
  end
end
