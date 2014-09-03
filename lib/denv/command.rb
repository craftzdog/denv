require 'optparse'

module Denv
  class Command

    def initialize(argv)

      subtext = <<HELP
Commonly used sub-commands are:
   init   :  Create a Denvfile
   up     :  Create a container
   rm     :  Destroy running container
   status :  Display running container status
   attach :  Attach to specified container
   login  :  Connect to running container via SSH
 
See 'denv SUBCOMMAND --help' for more information on a specific sub-command.
HELP

      # Default options
      @options = OpenStruct.new
      @options.filetype = "xcconfig"
      @options.force = false

      global = OptionParser.new do |opts|
        opts.banner = "Usage: denv [options] [subcommand [options]]"
        opts.separator ""
        opts.separator subtext
      end
      
      subcommands = {
        'init' => OptionParser.new do |opts| 
          opts.banner = "Usage: denv init [options] IMAGE"
          opts.on('-h', '--host=URI', "URI to Docker daemon. Default: #{DockerUrl}"){|v| @options.output = v }
        end,
        'up' => OptionParser.new do |opts| 
          opts.banner = "Usage: denv up [options]"
          opts.on('-o FileName', '--output=FileName', "Destination to output denv info"){|v| @options.output = v }
          opts.on('-t FileType', '--type=FileType', "Output file type: xcconfig(Default), json"){|v| @options.filetype = v }
          opts.on('-f', '--force', "Force to create a container. Existing container will be removed."){|v| @options.force = v }
        end,
        'rm' => OptionParser.new do |opts| 
          opts.banner = "Usage: denv rm [options]"
        end,
        'status' => OptionParser.new do |opts| 
          opts.banner = "Usage: denv status"
        end,
        'attach' => OptionParser.new do |opts|
          opts.banner = "Usage: denv attach [options] CONTAINER"
          opts.on('-o FileName', '--output=FileName', "Destination to output denv info"){|v| @options.output = v }
          opts.on('-t FileType', '--type=FileType', "Output file type: xcconfig(Default), json"){|v| @options.filetype = v }
          opts.on('-f', '--force', "Force to create a container. Existing container will be removed."){|v| @options.force = v }
        end,
        'login' => OptionParser.new do |opts|
          opts.banner = "Usage: denv login"
        end
      }
      subcommands['st'] = subcommands['status']
      subcommands.default_proc = ->(h,k){
        $stderr.puts "no such subcommand: #{k}"
        exit 1
      }

      global.order!(argv)
      unless argv.empty?
        @command = argv.shift
        subcommands[@command].parse!(argv) 
      else
        puts global
      end

      @argv = argv
    end

    def self.run(argv)
      new(argv).execute
    end

    def execute
      unless @command.nil?
        begin
          cmd = Subcommand.new @argv, @options
          cmd.send @command
        rescue => e
          Denv.failure "Command execution failed!", e
        end
      end
    end

  end
end


