module Denv
  class Config
    def initialize
    end

    # Methods for Denvfile

    def denv
      self
    end

    def docker
      Docker
    end

    def container
      @container = @container || OpenStruct.new
      @container.create_param = @container.create_param || {}
      @container.start_param  = @container.start_param || {}
      @container.on_start = Proc.new do |&blk|
        @container.on_start_block = blk
      end
      @container.on_destroy = Proc.new do |&blk|
        @container.on_destroy_block = blk
      end
      @container
    end

    def load_from_file(file=nil)
      file = "./#{DenvFileName}" if file.nil?
      f = File.open(file).read
      instance_eval f
    end

    def save_to_file(file=nil)
      file = "./#{DenvFileName}" if file.nil?
      f = File.open(file, 'w')
      f.puts "docker.url = '#{Docker.url}'"
      f.puts ""
      f.puts "container.create_param = #{container.create_param.pretty_inspect}"
      f.puts ""
      f.puts "container.start_param = #{container.start_param.pretty_inspect}"
      f.puts ""
      f.puts "container.on_start do"
      f.puts "end"
      f.puts ""
      f.puts "container.on_destroy do"
      f.puts "end"
      f.close
    end

  end
end
