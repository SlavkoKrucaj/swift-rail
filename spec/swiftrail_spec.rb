require 'swiftrail/quicknimble/parser'

RSpec.describe Swiftrail::QuickNimble do
  describe 'extract_information' do
    context 'with multiple cases' do
      parser = Swiftrail::QuickNimble::Parser.new
      it 'retreives array of cases' do
        expected_result = Swiftrail::QuickNimble::Parser::RegexMatch.new(
            ["12345", "6789", "98432"],
            "MyFinalTests__C12345_C6789_C98432__when_getting_a_transaction__has_an_output_value"
        )
        expect(
            parser.extract_information(
                "MyFinalTests__C12345_C6789_C98432__when_getting_a_transaction__has_an_output_value"
            )
        ).to eq(expected_result)
      end

      it 'retreives array with one case' do
        expected_result = Swiftrail::QuickNimble::Parser::RegexMatch.new(
            ["2222"],
            "MyFinalTests__C2222__when_getting_a_transaction__has_an_output_value"
        )
        expect(
            parser.extract_information(
                "MyFinalTests__C2222__when_getting_a_transaction__has_an_output_value"
            )
        ).to eq(expected_result)
      end

      it 'retreives array with one case with lowercase' do
        expected_result = Swiftrail::QuickNimble::Parser::RegexMatch.new(
            ["3333", "44444", "555555"],
            "MyFinalTests__C3333_c44444_C555555__when_getting_a_transaction__has_an_output_value"
        )
        expect(
            parser.extract_information(
                "MyFinalTests__C3333_c44444_C555555__when_getting_a_transaction__has_an_output_value"
            )
        ).to eq(expected_result)
      end

      it 'retreives empty array when name not contains any cases ids' do
        expected_result = Swiftrail::QuickNimble::Parser::RegexMatch.new(
            [],
            "MyFinalTests_when_getting_a_transaction__has_an_output_value"
        )
        expect(
            parser.extract_information(
                "MyFinalTests_when_getting_a_transaction__has_an_output_value"
            )
        ).to eq(expected_result)
      end

      it 'retreives empty array when name wrongly formatted' do
        expected_result = Swiftrail::QuickNimble::Parser::RegexMatch.new(
            [],
            "MyFinalTests_C12345_C6789_C98432_when_getting_a_transaction__has_an_output_value"
        )
        expect(
            parser.extract_information(
                "MyFinalTests_C12345_C6789_C98432_when_getting_a_transaction__has_an_output_value"
            )
        ).to eq(expected_result)
      end
    end
  end
end