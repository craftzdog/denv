
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

      @conf.save_to_file

      puts "Denvfile created.".green
    end

    # Create a container
    def up
      begin
        @conf.load_from_file
      rescue => e
        Denv.failure "Failed to load Denvfile.", e
      end

      status = Status.new
      if status.container_running?
        puts "The container is running.".yellow
        puts "Container ID: #{status.container.id}".green
        exit 0
      end

      # Validate config
      Denv.failure "image is not specified in your Denvfile." if @conf.container.create_param['Image'].nil?

      # Create a container
      puts "Creating a docker container.."
      @container = Docker::Container.create @conf.container.create_param

      # Start running the container
      puts "Start running the container.."
      @container.start @conf.container.start_param

      puts ""
      puts "Successfully launch container #{@container.id}".green

      output

      status = Status.new @container
      status.save_to_file

      # invoke handler
      @conf.container.on_start_block.call unless @conf.container.on_start_block.nil?

    end

    def rm
      begin
        @conf.load_from_file
      rescue => e
        Denv.failure "Failed to load Denvfile.", e
      end

      status = Status.new
      if status.container_running?
        @container = status.container
        puts "Deleting container..#{@container.id}"
        @container.delete(:force => true)
        puts "OK".green
      end
      status.delete

      # invoke handler
      @conf.container.on_destroy_block.call unless @conf.container.on_destroy_block.nil?
    end

    def status

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

