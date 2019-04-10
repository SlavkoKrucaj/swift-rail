module Swiftrail
  module Testrail
    module Api
      # noinspection RubyConstantNamingConvention
      TestCaseResult = Struct.new(:case_id, :comment, :duration, :status) do
        def to_json(*_args)
          {
            case_id: case_id,
            status_id: status,
            comment: comment,
            elapsed: duration
          }
        end

        def self.from(case_id, results)
          TestCaseResult.new(case_id, comment(results), duration(results), status(results))
        end

        def self.status(results)
          results.map(&:success?).all? ? 1 : 5
        end

        def self.comment(results)
          comments = results.map do |result|
            value = " - #{result.success? ? '**SUCCESS**' : '**FAILURE**'}, `#{result.class_name}.#{result.test_name}` in `#{result.file_name}`"
            value += " with following errors \n" + result.failures.map { |message| "   + `#{message}`"}.join("\n") unless result.success?
            value
          end
          (['#Results:#'] + comments + ['']).join("\n")
        end

        def self.duration(results)
          format('%.2fs', results.map(&:duration).sum)
        end
      end
    end
  end
end
