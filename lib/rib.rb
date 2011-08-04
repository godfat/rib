
require 'rib/shell'

module Rib
  def self.start(*argv)
    require 'rib/runner'
    Runner.run(*argv)
  end

  def self.shell
    @shell ||= Shell.new
  end
end
