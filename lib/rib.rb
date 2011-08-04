
require 'rib/shell'

module Rib
  def self.config
    @config ||= {}
  end

  def self.shell
    @shell  ||= (shells << Shell.new(config)).last
  end

  def self.shells
    @shells ||= []
  end

  def self.vars
    @vars   ||= {}
  end

  def self.start(*argv)
    require 'rib/runner'
    Runner.run(argv)
  end
end
