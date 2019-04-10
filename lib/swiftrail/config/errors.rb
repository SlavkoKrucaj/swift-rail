require 'swiftrail/errors/error'

module Swiftrail
  module Config
    module Error
      class InvalidFile < Errors::Base
        def initialize(file)
          super("Config file (#{file}) for swiftrail is not valid")
        end
      end
    end
  end
end
