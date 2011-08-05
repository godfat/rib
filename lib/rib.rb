
require 'rib/shell'

module Rib
  module_function
  def config
    @config ||= {:config => '~/.config/rib/config.rb'}
  end

  def shells
    @shells ||= []
  end

  def vars
    @vars   ||= {}
  end

  def shell
    @shell  ||= begin
      load_rc
      (shells << Shell.new(config)).last
    end
  end

  def load_rc
    config[:config] &&
      File.exist?(rc = File.expand_path(config[:config])) &&
      require(rc)
  end
end
