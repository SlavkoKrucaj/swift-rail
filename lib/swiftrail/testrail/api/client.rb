require 'net/https'
require 'uri'
require 'json'

require 'swiftrail/testrail/api/error'
require 'swiftrail/testrail/api/test_rail_test'

module Swiftrail
  module Testrail
    module Api
      class Client
        def initialize(base_url, username, password, run_id)
          @conn = connection(URI.parse(base_url))
          @run_id = run_id
          @username = username
          @password = password
        end

        def publish_results(results)
          response = conn.request(post_request(publish_result_path, results))

          raise Error::InvalidRequest.new(response) if response.code == '400'
          raise Error::NoPermission(response) if response.code == '403'
          raise Error::Unknown(response), response.code unless response.code == '200'

          true
        end

        # @return [TestRailTest]
        def all_tests
          response = conn.request(get_request(tests_for_run_path))

          raise Error::InvalidRequest.new(response) if response.code == '400'
          raise Error::NoPermission(response) if response.code == '403'
          raise Error::Unknown(response), response.code unless response.code == '200'

          JSON.parse(response.body).map do |item|
            TestRailTest.from_json(item)
          end
        end

        private

        attr_reader :conn, :run_id, :username, :password

        def connection(url)
          conn = Net::HTTP.new(url.host, url.port)
          conn.use_ssl = true
          conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
          conn
        end

        def post_request(path, results)
          request = Net::HTTP::Post.new(path)
          request.body = JSON.dump(post_json(results))
          request.basic_auth(username, password)
          request.add_field('Content-Type', 'application/json')
          request
        end

        def get_request(path)
          request = Net::HTTP::Get.new(path)
          request.basic_auth(username, password)
          request.add_field('Content-Type', 'application/json')
          request
        end

        def post_json(results)
          { results: results.map(&:to_json) }
        end

        def publish_result_path
          "/index.php?/api/v2/add_results_for_cases/#{run_id}"
        end

        def tests_for_run_path
          "/index.php?/api/v2/get_tests/#{run_id}"
        end
      end
    end
  end
end
