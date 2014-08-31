require "denv/version"
require "denv/config"
require "denv/command"
require "denv/subcommand"
require "denv/consts"
require "denv/status"
require "denv/format/xcconfig"
require "denv/format/json"
require "docker"
require "pp"
require 'colorize'

module Denv

  def self.failure(msg, e=nil)
    STDERR.puts "#{msg}".red
    STDERR.puts e unless e.nil?
    exit 1
  end

end
