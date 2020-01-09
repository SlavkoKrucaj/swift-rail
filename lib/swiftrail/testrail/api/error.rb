require 'swiftrail/errors/error'

module Swiftrail
  module Testrail
    module Api
      module Error
        class InvalidRequest < Errors::Base
          def initialize(error_response)
            super("Invalid or unknown test run/cases #{error_response.body}")
          end
        end

        class NoPermission < Errors::Base
          def initialize(error_response)
            super("No permissions to add test results or no access to the project #{error_response.body}")
          end
        end

        class Unknown < Errors::Base
          def initialize(error_response)
            super("There has been an unknown error #{error_response.body}")
          end
        end
      end
    end
  end
end
