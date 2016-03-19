#!/usr/bin/ruby

require 'io/console'

class Shell
  attr_accessor :settings

  class Command
    attr_accessor :input
    attr_reader :console

    def initialize cmd, console
      @input = cmd.chomp
      @console = console
    end

    def run!
      if executable_file? @input
        return `#{@input}`
      end

      eval @input
    rescue
      "unknown command #{@input}"
    end

    private

    def executable_file? filename
      console.settings[:path].any? do |path|
        File.file? "#{path}/#{filename}" #todo check if executable
      end
    end
  end

  def initialize
    @settings = {
      prompt: 'shh',
      editor: 'nano',
      path: [
        '/bin', '/usr/bin', '/usr/local/bin', '/usr/sbin', '/opt/X11/bin'
      ],
      cwd: `pwd`
    }
  end

  def run!
    loop do
      input_prompt
      line = gets
      #line = STDIN.raw(&:gets)

      command = Command.new line, self
      puts "=> #{command.run!}"
    end
  rescue
    puts "shell crashed.. restarting"
    retry
  end

  private

  def input_prompt
    print "#{@settings[:prompt] || 'shh'} $ "
  end
end

@shh = Shell.new
@shh.run!
