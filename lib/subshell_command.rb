require "subshell_command/version"
require "open3"

module SubshellCommand
  VERSION = "0.1.0"

  class Command
    attr_reader :command_string
    attr_reader :env_hash, :current_directory
    attr_reader :success_callback, :failure_callback
    attr_reader :redirect_stderr_to_stdout

    def initialize(command_string)
      @command_string = command_string
      @env_hash = {}
      @current_directory = Dir.pwd
      @success_callback = ->{}
      @failure_callback = ->{}
      @redirect_stderr_to_stdout = false
    end

    def cmd=(command_string)
      @command_string = command_string
    end

    def env=(env_hash)
      @env_hash = env_hash
    end

    def current_directory=(directory_string)
      @current_directory = directory_string
    end

    def on_success=(callback)
      @success_callback = callback
    end

    def on_failure=(callback)
      @failure_callback = callback
    end

    def redirect_stderr_to_stdout=(value)
      @redirect_stderr_to_stdout = value
    end
  end

  class Result
    attr_accessor :success, :stdout_value, :stderr_value

    def initialize
      @success = nil
      @stdout_value = nil
      @stderr_value = nil
    end

    def success?
      @success
    end
  end

  class StandardOutputStreamsExecutor
    attr_reader :command_object, :result

    def initialize(command_object, result)
      @command_object = command_object
      @result = result
    end

    def execute
      Open3.popen3(
        command_object.env_hash,
        command_object.command_string,
        chdir: command_object.current_directory,
      ) do |stdin, stdout, stderr, wait_thr|
        exit_status = wait_thr.value
        result.stdout_value = stdout.read
        result.stderr_value = stderr.read
        result.success = exit_status.success?
      end
    end
  end

  class CombinedOutputStreamsExecutor
    attr_reader :command_object, :result

    def initialize(command_object, result)
      @command_object = command_object
      @result = result
    end

    def execute
      Open3.popen2e(
        command_object.env_hash,
        command_object.command_string,
        chdir: command_object.current_directory,
      ) do |stdin, output_streams, wait_thr|
        exit_status = wait_thr.value
        output_value = output_streams.read
        result.stdout_value = output_value
        result.stderr_value = output_value
        result.success = exit_status.success?
      end
    end
  end

  class CommandExecutor
    attr_reader :command_object

    EXECUTORS = {
      true => CombinedOutputStreamsExecutor,
      false => StandardOutputStreamsExecutor,
    }

    def initialize(command_object)
      @command_object = command_object
    end

    def execute
      result = Result.new
      EXECUTORS[command_object.redirect_stderr_to_stdout].new(command_object, result).execute
      execute_callbacks(result)
      result
    end

    private

    def execute_callbacks(result)
      if result.success?
        command_object.success_callback.call(result)
      else
        command_object.failure_callback.call(result)
      end
    end
  end

  class << self
    def execute(command_string = nil, &block)
      command = Command.new(command_string)
      block.call(command) if block_given?
      CommandExecutor.new(command).execute
    end
  end
end
