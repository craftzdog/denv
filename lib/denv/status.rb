
module Denv
  class Status

    def initialize(container=nil)
      unless container.nil?
        @container = container
        @info = container.json
      else
        load_from_file
      end
    end

    def save_to_file

      f = File.open(StatusFileName, 'w')
      f.puts JSON.pretty_generate(@info)
      f.close

    end

    def load_from_file

      if File.exist?(StatusFileName)
        @info = open(StatusFileName) do |io|
          JSON.load(io)
        end

        true
      else
        false
      end

    end
 
    def container
      return @container unless @container.nil?
      if @info.nil?
        nil
      else
        begin
          @container = Docker::Container.get @info["Id"]
        rescue => e
          nil
        end
      end
    end

    def container_running?
      not container.nil?
    end

    def info
      @info
    end

    def delete
      File.delete  StatusFileName
    end

  end
end


