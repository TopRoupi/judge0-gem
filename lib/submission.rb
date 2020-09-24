module Judge0
  class Submission
    attr_accessor :source_code, :language_id, :number_of_runs, :stdin,
                  :expected_output, :cpu_time_limit, :cpu_extra_time,
                  :wall_time_limit, :memory_limit, :stack_limit,
                  :max_processes_and_or_threads,
                  :enable_per_process_and_thread_time_limit,
                  :enable_per_process_and_thread_memory_limit,
                  :max_file_size

    attr_reader :token, :stdout, :time, :memory, :stderr, :compile_out,
                :status_id, :status_description

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def run
      res = wait_response(get_token)

      @stdout = res['stdout']
      @time = res['time'].to_f
      @memory = res['memory']
      @stderr = res['stderr']
      @compile_out = res['compile_out']
      @message = res['message']
      @status_id = res['status']['id']
      @status_description = res['status']['description']

      result
    end

    def tests_battery (tests)
      tests.map! do |test|
        if test.respond_to?(:input) && test.respond_to?(:output)
          @stdin = test.input
          @expected_output = test.output
        elsif test.include?(:input) && test.respond_to?(:output)
          @stdin = test[:input]
          @expected_output = test[:output]
        else
          @stdin = test[0]
          @expected_output = test[1]
        end
        get_token
      end
      tests.map do |test|
        wait_response(test)
      end
    end

    def result
      {
        stdout: @stdout,
        time: @time,
        memory: @memory,
        stderr: @stderr,
        compile_out: @compile_out,
        message: @message,
        status: {
          id: @status_id,
          description: @status_description
        }
      }
    end

    def output
      msg = @stdout
      msg +="\nERROR:\n#{@stderr}" if @stderr
      msg += "\nMESSAGE:\n#{@message}" if @message
      msg
    end

    private

    def to_hash
      Hash[
        instance_variables.map do |name|
          [name[1..-1].to_sym, instance_variable_get(name)]
        end
      ]
    end

    def get_token
      resp = Faraday.post(Judge0.url('/submissions/?base64_encoded=false&wait=false'), to_hash)
      @token = JSON.parse(resp.body)['token']
    end

    def wait_response(token)
      begin
        resp = Faraday.get(Judge0.url("/submissions/#{token}"))
        body = JSON.parse(resp.body)
        puts "waiting: #{token} - #{body['status']['description']}" unless ENV['RAILS_ENV'] == 'test'
      end while body['status']['id'] <= 2
      body
    end
  end
end
