
require 'rib/shell'

module Rib
  autoload :VERSION, 'rib/version'
  Skip = Object.new

  module_function
  # All default Rib configs, would be passed to Shell.new in Rib.shell,
  # but calling Shell.new directly won't bring this in.
  def config
    @config ||= {:config => File.join(home, 'config.rb'), :name => 'rib'}
  end

  # All shells in the memory
  def shells
    @shells ||= []
  end

  # All shared variables for all shells
  def vars
    @vars   ||= {}
  end

  # Rib.home is where Rib storing things
  def home
    ENV['RIB_HOME'] ||= begin
      ['~/.rib', '~/.config/rib'].find{ |path|
        p = File.expand_path(path)
        File.exist?(File.join(p, 'config.rb')) ||
        File.exist?(File.join(p, 'history.rb'))
      } || '~/.rib'
    end
  end

  # Convenient shell accessor, which would just give you current last shell
  # or create one and load ~/.config/rib/config.rb if non has existed. If you
  # need a clean shell which does not load rc file, use Shell.new instead.
  def shell
    shells.last || begin
      require_config if config_path
      (shells << Shell.new(config)).last
    end
  end

  # All plugins which have been loaded into the memory regardless
  # it's enabled or not.
  def plugins
    Shell.ancestors[1..-1].select{ |a| a.singleton_class < Plugin }
  end

  # Convenient way to disable all plugins in the memory.
  # This could also take a list of plugins and disable them.
  def disable_plugins plugs=plugins
    plugs.each(&:disable)
  end

  # Convenient way to enable all plugins in the memory.
  # This could also take a list of plugins and enable them.
  def enable_plugins plugs=plugins
    plugs.each(&:enable)
  end

  # Load (actually require) ~/.config/rib/config.rb if exists.
  # This might emit warnings if there's some error while loading it.
  def require_config
    return unless config_path
    result = require(config_path)
    Rib.say("Config loaded from: #{config_path}") if $VERBOSE && result
    result
  rescue StandardError, LoadError, SyntaxError => e
    Rib.warn("Error loading #{config[:config]}\n" \
             "  #{Rib::API.format_error(e)}")
  end

  # The config path where Rib tries to load upon Rib.shell
  def config_path
    return nil unless config[:config]
    path = File.expand_path(config[:config])
    if File.exist?(path)
      path
    else
      nil
    end
  end

  # Say (print to $stdout, with colors in the future, maybe)
  # something by the name of Rib
  def say *words
    $stdout.puts(Rib.prepare(words))
  end

  # Warn (print to $stderr, with colors in the future, maybe)
  # something by the name of Rib
  def warn *words
    $stderr.puts(Rib.prepare(words))
  end

  # Warn (print to $stderr, with colors in the future, maybe)
  # something by the name of Rib and then exit(1)
  def abort *words
    warn(words)
    exit(1)
  end

  def silence
    w, v = $-w, $VERBOSE
    $-w, $VERBOSE = false, false
    yield
  ensure
    $-w, $VERBOSE = w, v
  end

  private
  def self.prepare words
    name = config[:name]
    "#{name}: #{words.join("\n#{' '*(name.size+2)}")}"
  end
end
