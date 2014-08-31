require 'uri'

module Denv
  module Format
    class XCConfig
      def initialize(container)
        @container = container
      end

      def ports
        ret = {}
        @container.json["NetworkSettings"]["Ports"].each do |key,val|
          port = key.split("/")[0]
          ret[port] = val.nil? ? "" : val[0]["HostPort"]
        end

        ret
      end

      def save_to_file(file=nil)

        file = "./Denv.xcconfig" if file.nil?

        f = File.open(file, 'w')
        f.puts "DOCKER_HOST = #{URI.parse(Docker.url).host}"
        f.puts "CONTAINER_ID = #{@container.id}"
        f.puts "CONTAINER_NAME = #{@container.json["Name"]}"
        f.puts "CONTAINER_HOSTNAME = #{@container.json["Config"]["Hostname"]}"
        f.puts "CONTAINER_IMAGE = #{@container.json["Image"]}"

        ports.each do |bind, host|
          f.puts "CONTAINER_PORT_#{bind} = #{host}"
        end
        f.close

      end

    end
  end
end

