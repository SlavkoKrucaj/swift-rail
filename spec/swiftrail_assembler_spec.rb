require 'swiftrail/testrail/assembler'

RSpec.describe Swiftrail::Testrail::Assembler do
  describe 'search cases ids' do
    swiftTest =  Swiftrail::Swift::Test.new("Testfile.swift", "RendomTestClass", "Test_C3456_other_irrelevant_test", [])
    testCase = Swiftrail::Junit::TestCase.new("TestCase", "TestClass", "test__C12012__myTest", [], 12.0)
    testSuite = Swiftrail::Junit::TestSuite.new("TestSuite", [testCase])
    assembler = Swiftrail::Testrail::Assembler.new([swiftTest], [testSuite])

    it 'assemble and report success' do
      #expected_result = Swiftrail::Testrail::Api::TestCaseResult.new("C12012", "#Results:#\n - **SUCCESS**, `#<struct Swiftrail::Junit::TestCase full_class_name=\"TestCase\", class_name=\"TestClass\", test_name=\"test__C12012__myTest\", failures=[], duration=12.0>.#<struct Swiftrail::Junit::TestCase full_class_name=\"TestCase\", class_name=\"TestClass\", test_name=\"test__C12012__myTest\", failures=[], duration=12.0>` in `#<struct Swiftrail::Junit::TestCase full_class_name=\"TestCase\", class_name=\"TestClass\", test_name=\"test__C12012__myTest\", failures=[], duration=12.0>`\n", "12.00s", 1)
      #expect(
      #    assembler.assemble
      #).to eq(expected_result)
    end
  end
end