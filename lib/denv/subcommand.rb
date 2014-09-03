require 'uri'

module Denv
  class Subcommand

    def initialize(argv, options)
      @argv = argv
      @options = options
      @conf = Config.new
    end

    # Create a Denvfile
    def init
      Denv.failure "IMAGE must be specified." if @argv.length < 1
      @conf = Config.new
      Docker.url = @options.host || DockerUrl
      @conf.container.create_param = {
        'Image' => @argv[0]
      }
      @conf.container.start_param = {
        'PublishAllPorts' => true
      }

      @conf.save_to_file

      puts "Denvfile created.".green
    end

    def load_config
      begin
        @conf.load_from_file
      rescue => e
        Denv.failure "Failed to load Denvfile.", e
      end
    end

    # Check if the container running.
    # Exit if running
    # Remove it if 'force' option enabled
    def check_running
      status = Status.new
      if status.container_running?
        unless @options.force
          puts "The container is running.".yellow
          puts "Container ID: #{status.container.id}".green
          exit 0
        else
          rm
        end
      end
    end

    # Create a container
    def up
      load_config

      check_running

      # Validate config
      Denv.failure "image is not specified in your Denvfile." if @conf.container.create_param['Image'].nil?

      # Create a container
      puts "Creating a docker container.."
      @container = Docker::Container.create @conf.container.create_param

      # Start running the container
      puts "Start running the container.."
      @container.start @conf.container.start_param

      puts ""
      puts "Successfully launched container #{@container.id}".green

      output

      status = Status.new @container
      status.save_to_file

      # invoke handler
      @conf.container.on_start_block.call unless @conf.container.on_start_block.nil?

    end

    def rm
      load_config

      status = Status.new
      if status.container_running?
        @container = status.container
        puts "Deleting container..#{@container.id}"
        @container.delete(:force => true)
        puts "OK".green
      else
        puts "Container is not running.".yellow
      end
      status.delete

      # invoke handler
      @conf.container.on_destroy_block.call unless @conf.container.on_destroy_block.nil?
    end

    def status
      load_config

      status = Status.new
      if status.container_running?

        @container = status.container
        puts "Container ID: #{@container.id}".green
        puts "Container Name = #{@container.json["Name"]}".green
        puts "Container Hostname = #{@container.json["Config"]["Hostname"]}".green
        puts "Container Image = #{@container.json["Image"]}".green

      else

        puts "Container is not running.".yellow

      end
    end

    def st
      status
    end

    def attach
      load_config
      Denv.failure "CONTAINER must be specified." if @argv.length < 1
      container_id = @argv[0]

      check_running

      puts "Attaching to a docker container..#{container_id}"
      @container = Docker::Container.get container_id

      puts ""
      puts "Successfully attached container #{@container.id}".green

      output

      status = Status.new @container
      status.save_to_file
    end

    def login
      load_config

      status = Status.new
      if status.container_running?

        @container = status.container
        network_settings = @container.json["NetworkSettings"]

        unless network_settings.nil? ||
          network_settings["Ports"].nil? ||
          network_settings["Ports"]["22/tcp"].nil?

          port = network_settings["Ports"]["22/tcp"][0]["HostPort"]
          host = URI.parse(Docker.url).host

          exec "ssh #{host} -p #{port}"
        else
          Denv.failure "The container does not expose port 22"
        end

      else
        Denv.failure "Container is not running."
      end
    end

    def output

      case @options.filetype
      when "xcconfig"
        format = Format::XCConfig.new @container
      when "json"
        format = Format::JSON.new @container
      end

      format.save_to_file @options.output
    end

  end
end

