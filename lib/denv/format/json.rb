require 'uri'

module Denv
  module Format
    class JSON
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

      def save_to_file(file)

        file = "./Denv.json" if file.nil?

        f = File.open(file, 'w')
        f.puts ::JSON.pretty_generate(@container.json)
        f.close

      end

    end
  end
end


