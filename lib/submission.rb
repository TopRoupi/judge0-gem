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

    def get_token
      resp = Faraday.post('https://api.judge0.com/submissions', to_hash)
      @token = JSON.parse(resp.body)['token']
    end

    def run
      begin
        resp = Faraday.get("https://api.judge0.com/submissions/#{get_token}")
        body = JSON.parse(resp.body)
        status = body['status']['id']
      end while status == 2

      @stdout = body['stdout']
      @time = body['time'].to_f
      @memory = body['memory']
      @stderr = body['stderr']
      @compile_out = body['compile_out']
      @message = body['message']
      @status_id = body['status']['id']
      @status_description = body['status']['description']

      result
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

    def to_hash
      Hash[instance_variables.map { |name| [name[1..-1].to_sym, instance_variable_get(name)] } ]
    end
  end
end