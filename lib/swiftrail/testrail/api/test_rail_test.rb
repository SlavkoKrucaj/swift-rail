module Swiftrail
  module Testrail
    module Api
      TestRailTest = Struct.new(:case_id, :id, :title) do
        def self.from_json(json)
          TestRailTest.new(json['case_id'], json['id'], json['title'])
        end

        def to_json(*_args)
          {
            id: id,
            case_id: case_id,
            title: title
          }
        end
      end
    end
  end
end
