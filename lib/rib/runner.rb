# frozen_string_literal: true

require 'rib'

module Rib; module Runner
  module_function
  def options
    @options ||=
    [['ruby options:'    , ''                                      ],
     ['-e, --eval LINE'                                             ,
      'Evaluate a LINE of code'                                    ],

     ['-d, --debug'                                                 ,
      'Set debugging flags (set $DEBUG to true)'                   ],

     ['-w, --warn'                                                  ,
       'Turn warnings on (set $-w and $VERBOSE to true)'           ],

     ['-I, --include PATH'                                          ,
       'Specify $LOAD_PATH (may be used more than once)'           ],

     ['-r, --require LIBRARY'                                       ,
       'Require the library, before executing your script'         ],

     ['rib options:'     , ''                                      ],
     ['-c, --config FILE', 'Load config from FILE'                 ],
     ['-p, --prefix PATH', 'Prefix to locate the app. Default to .'],
     ['-n, --no-config'  , 'Suppress loading any config'           ],
     ['-h, --help'       , 'Print this message'                    ],
     ['-v, --version'    , 'Print the version'                     ]] +

    [['rib commands:'    , '']] + commands
  end

  def commands
     @commands ||=
      command_paths.map{ |path|
        name = File.basename(path)[/^rib\-(.+)$/, 1]
        [name, command_descriptions[name]      ||
               command_descriptions_find(path) || ' '] }
  end

  def command_paths
    @command_paths ||=
    Gem.path.map{ |path|
      Dir["#{path}/bin/*"].map{ |f|
        (File.executable?(f) && File.basename(f) =~ /^rib\-.+$/ && f) ||
         nil    # a trick to make false to be nil and then
      }.compact # this compact could eliminate them
    }.flatten
  end

  def command_descriptions
    @command_descriptions ||=
    {'all'    => 'Load all recommended plugins'              ,
     'min'    => 'Run the minimum essence'                   ,
     'auto'   => 'Run as Rails or Rack console (auto-detect)',
     'rails'  => 'Run as Rails console'                      ,
     'rack'   => 'Run as Rack console'                       }
  end

  # Extract the text below __END__ in the bin file as the description
  def command_descriptions_find path
    # FIXME: Can we do better? This is not reliable
    File.read(path) =~ /Gem\.activate_bin_path\(['"](.+)['"], ['"](.+)['"],/
    (File.read(Gem.bin_path($1, $2))[/\n__END__\n(.+)$/m, 1] || '').strip
  end

  def run argv=ARGV
    (@running_commands ||= []) << Rib.config[:name]
    unused = parse(argv)
    # we only want to run the loop if we're running the rib command,
    # otherwise, it must be a rib app, which we only want to parse
    # the arguments and proceed (this is recursive!)
    if @running_commands.pop == 'rib'
      Rib.warn("Unused arguments: #{unused.inspect}") unless unused.empty?
      require 'rib/core' if Rib.config.delete(:mimic_irb)
      loop
    end
  end

  def loop retry_times=5
    Rib.shell.loop
  rescue => e
    if retry_times <= 0
      Rib.warn("Error: #{e}. Too many retries, give up.")
    elsif Rib.shells.last.running?
      Rib.warn("Error: #{e}. Relaunching a new shell... ##{retry_times}")
      Rib.warn("Backtrace: #{e.backtrace}") if $VERBOSE
      Rib.shells.pop
      Rib.shells << Rib::Shell.new(Rib.config)
      retry_times -= 1
      retry
    else
      Rib.warn("Error: #{e}. Closing.")
      Rib.warn("Backtrace: #{e.backtrace}") if $VERBOSE
    end
  end

  def parse argv
    unused = []
    until argv.empty?
      case arg = argv.shift
      when /^-e=?(.+)?/, /^--eval=?(.+)?/
        Rib.shell.eval_binding.eval(
          $1 || argv.shift || '', __FILE__, __LINE__)

      when /^-d/, '--debug'
        $DEBUG = true
        parse_next(argv, arg)

      when /^-w/, '--warn'
        $-w, $VERBOSE = true, true
        parse_next(argv, arg)

      when /^-I=?(.+)?/, /^--include=?(.+)?/
        paths = ($1 || argv.shift).split(':')
        $LOAD_PATH.unshift(*paths)

      when /^-r=?(.+)?/, /^--require=?(.+)?/
        require($1 || argv.shift)

      when /^-c=?(.+)?/, /^--config=?(.+)?/
        Rib.config_path = $1 || argv.shift

      when /^-p=?(.+)?/, /^--prefix=?(.+)?/
        Rib.config[:prefix] = $1 || argv.shift

      when /^-n/, '--no-config'
        Rib.config_path = Rib::Skip
        parse_next(argv, arg)

      when /^-h/, '--help'
        puts(help)
        exit

      when /^-v/, '--version'
        require 'rib/version'
        puts(Rib::VERSION)
        exit

      when /^[^-]/
        load_command(arg)

      else
        unused << arg
      end
    end
    unused
  end

  def parse_next argv, arg
    argv.unshift("-#{arg[2..-1]}") if arg.size > 2
  end

  def help
    optt = options.transpose
    maxn = optt.first.map(&:size).max
    maxd = optt.last .map(&:size).max
    "Usage: #{Rib.config[:name]}"                    \
    " [ruby OPTIONS] [rib OPTIONS] [rib COMMANDS]\n" +
    options.map{ |(name, desc)|
      if name.end_with?(':')
        name
      else
        sprintf("  %-*s  %-*s", maxn, name, maxd, desc)
      end
    }.join("\n")
  end

  def load_command command
    bin  = "rib-#{command}"
    path = which_bin(bin)
    if path == ''
      Rib.warn(
        "Can't find #{bin} in $PATH. Please make sure it is installed,",
        "or is there any typo? You can try this to install it:\n"      ,
        "    gem install #{bin}")
    else
      Rib.config[:name] = bin
      load(path)
    end
  end

  def which_bin bin # handle windows here
    `which #{bin}`.strip
  rescue Errno::ENOENT # probably a windows platform, try where
    `where #{bin}`.lines.first.strip
  end
end; end
