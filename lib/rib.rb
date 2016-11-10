
require 'rib/shell'

module Rib
  autoload :VERSION, 'rib/version'
  Skip = Object.new

  module_function
  # All default Rib configs, would be passed to Shell.new in Rib.shell,
  # but calling Shell.new directly won't bring this in.
  #
  # @api public
  def config
    @config ||= {:name => 'rib',
                 :config => File.join(home, 'config.rb'),
                 :prefix => '.'}
  end

  # All shells in the memory
  def shells
    @shells ||= []
  end

  # All shared variables for all shells
  def vars
    @vars   ||= {}
  end

  # Rib.home is where Rib storing things. By default, it goes to '~/.rib',
  # or somewhere containing a 'config.rb' or 'history.rb' in the order of
  # './.rib' (project specific config), or '~/.rib' (home config), or
  # '~/.config/rib' (home config, residing in ~/.config)
  #
  # @api public
  def home
    ENV['RIB_HOME'] ||= File.expand_path(
      ["#{config[:prefix]}/.rib", '~/.rib', '~/.config/rib'].find{ |path|
        File.exist?(File.expand_path(path))
      } || '~/.rib'
    )
  end

  # Convenient shell accessor, which would just give you current last shell
  # or create one and load the config file. If you need a clean shell which
  # does not load config file, use Shell.new instead.
  #
  # @api public
  def shell
    shells.last || begin
      require_config if config_path
      (shells << Shell.new(config)).last
    end
  end

  # All plugins which have been loaded into the memory regardless
  # it's enabled or not.
  #
  # @api public
  def plugins
    Shell.ancestors.drop(1).select{ |a| a.singleton_class < Plugin }
  end

  # Convenient way to disable all plugins in the memory.
  # This could also take a list of plugins and disable them.
  #
  # @api public
  # @param plugs [Array] (Rib.plugins) Plugins which would be disabled.
  def disable_plugins plugs=plugins
    plugs.each(&:disable)
  end

  # Convenient way to enable all plugins in the memory.
  # This could also take a list of plugins and enable them.
  #
  # @api public
  # @param plugs [Array] (Rib.plugins) Plugins which would be enabled.
  def enable_plugins plugs=plugins
    plugs.each(&:enable)
  end

  # Load (actually require) the config file if it exists.
  # This might emit warnings if there's some error while loading it.
  #
  # @api public
  def require_config
    return unless config_path
    result = require(config_path)
    Rib.say("Config loaded from: #{config_path}") if $VERBOSE && result
    result
  rescue StandardError, LoadError, SyntaxError => e
    Rib.warn("Error loading #{config[:config]}\n" \
             "  #{Rib::API.format_error(e)}")
  end

  # The config path where Rib tries to load upon Rib.shell or
  # Rib.require_config. It is depending on where Rib.home was discovered
  # if no specific config path was specified via -c or --config command
  # line option. See also Rib.config.
  #
  # @api public
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
  # something by the name of Rib.
  #
  # @api public
  # @param words [Array[String]] Words you want to say.
  def say *words
    $stdout.puts(Rib.prepare(words))
  end

  # Warn (print to $stderr, with colors in the future, maybe)
  # something by the name of Rib.
  #
  # @api public
  # @param words [Array[String]] Words you want to warn.
  def warn *words
    $stderr.puts(Rib.prepare(words))
  end

  # Warn (print to $stderr, with colors in the future, maybe)
  # something by the name of Rib and then exit(1).
  #
  # @api public
  # @param words [Array[String]] Words you want to warn before aborting.
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
