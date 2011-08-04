
require 'rib/shell'

module Rib
  def self.config
    @config ||= {}
  end

  def self.shell
    @shell ||= Shell.new(config)
  end

  def self.start(*argv)
    require 'rib/runner'
    Runner.run(*argv)
  end
end
