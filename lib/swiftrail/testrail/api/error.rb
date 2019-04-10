require 'swiftrail/errors/error'

module Swiftrail
  module Testrail
    module Api
      module Error
        class InvalidRequest < Errors::Base
          def initialize
            super('Invalid or unknown test run/cases')
          end
        end

        class NoPermission < Errors::Base
          def initialize
            super('No permissions to add test results or no access to the project')
          end
        end

        class Unknown < Errors::Base
          def initialize(status_code)
            super("There has been an unknown error.rb (status code: #{status_code} while doing api request")
          end
        end
      end
    end
  end
end
