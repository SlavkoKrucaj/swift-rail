require 'swiftrail/testrail/assembler'
require 'active_support'
require 'active_support/core_ext'

RSpec.describe Swiftrail::Testrail::Assembler do
  describe 'search cases ids' do
    swiftTest =  Swiftrail::Swift::Test.new("Testfile.swift", "TestCsdmfnblass", "Test_Casdhjg120", [])
    testCase = Swiftrail::Junit::TestCase.new("TestCase", "TestClass", "test__C12012__myTest", [], 12.0)
    testSuite = Swiftrail::Junit::TestSuite.new("TestSuite", [testCase])
    assembler = Swiftrail::Testrail::Assembler.new([swiftTest], [testSuite])
    result = assembler.assemble
    print(result)
    it 'extracts case ids' do

    end
  end
end