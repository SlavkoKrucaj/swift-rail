require 'yaml'

module Swiftrail
  module Config
    class Reader
      def defaults
        raise Error::InvalidFile(defaults_file_name) unless valid_file?

        base_defaults.merge(file_defaults)
      end

      private

      def valid_file?
        file_defaults.is_a?(Hash)
      end

      def base_defaults
        {
          reports: '',
          strict: false,
          test_classes: '',
          test_rail_username: '',
          test_rail_password: '',
          test_rail_url: ''
        }
      end

      def file_defaults
        @file_defaults ||= if File.exist?(defaults_file_name)
                             YAML.safe_load(File.read(defaults_file_name))
                           else
                             {}
                           end
      end

      def defaults_file_name
        '.swiftrail.yml'
      end
    end
  end
end
