require_relative '../error_handeling/test_run_error'

module TMJ
  module Services
    # TNJ::Services::TestRun
    class TestRun < TMJ::Services::Base
      attr_reader :test_run_id

      def initialize(options = {})
        @test_run_id = options[:test_run_id]
        super(options)
      end

      def create(test_run_data)
        @response = self.class.post("/rest/kanoahtests/1.0/testrun", body: body.to_json, headers: @header)
        raise TMJ::TestRunError, response unless response.code == 201
        self
      end

      def find(test_run_id)
        @response = self.class.get("/rest/kanoahtests/1.0/testrun/#{test_run_id}", headers: @header)
        raise TMJ::TestRunError, response unless response.code == 200
        self
      end

      def delete(test_run_id)
        @response = self.class.get("/rest/kanoahtests/1.0/testrun/#{test_run_id}", headers: @header)
        raise TMJ::TestRunError, response unless response.code == 204
        self
      end

      def search(project_id)
        @response = self.class.get("/rest/kanoahtests/1.0/testrun/search?query=projectKey = '#{project_id}'", headers: @header)
        raise TMJ::TestRunError, response unless response.code == 200
        self
      end

      def create_new_test_run_result(test_run_key = @test_run_id, test_case_id, test_data)
        body = process_result(test_data)
        @response = self.class.post("/rest/kanoahtests/1.0/testrun/#{test_run_key}/testcase/#{test_case_id}/testresult", body: body.to_json, headers: @header)
        raise TMJ::TestRunError, response unless response.code == 201
        self
      end

      def update_last_test_run_result(test_run_key = @test_run_id, test_case_id, test_data)
        body = process_result(test_data)
        @response = self.class.post("/rest/kanoahtests/1.0/testrun/#{test_run_key}/testcase/#{test_case_id}/testresult", body: body.to_json, headers: @header)
        raise TMJ::TestRunError, response unless response.code == 200
        self
      end

      private
      def process_result(test_data)
        {
        'status'        => test_data[:status],
        'environment'   => @environment,
        'comment'       => test_data[:comment],
        'executionTime' => test_data[:execution_time],
        'scriptResults' => test_data[:script_results]
        }.delete_if { |k, v| v.nil? }
      end
    end
  end
end