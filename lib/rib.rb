
require 'rib/shell'

module Rib
  module_function
  def config
    @config ||= {:config => '~/.config/rib/config.rb', :name => 'rib'}
  end

  def shells
    @shells ||= []
  end

  def vars
    @vars   ||= {}
  end

  def shell
    shells.last || begin
      require_rc
      (shells << Shell.new(config)).last
    end
  end

  def plugins
    Shell.ancestors[1..-1].select{ |a| a < Plugin }
  end

  def disable_plugins plugs=plugins
    plugs.each(&:disable)
  end

  def enable_plugins plugs=plugins
    plugs.each(&:enable)
  end

  def require_rc
    config[:config] &&
      File.exist?(rc = File.expand_path(config[:config])) &&
      require(rc)
  rescue Exception => e
    Rib.warn("Error loading #{config[:config]}\n  #{e}")
  end

  def warn *words
    $stderr.puts(say(words))
  end

  def abort *words
    warn(say(words))
    exit(1)
  end

  def say words
    name = config[:name]
    "#{name}: #{words.join("\n#{' '*(name.size+2)}")}"
  end
end
