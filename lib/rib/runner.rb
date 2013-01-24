
require 'rib'

module Rib::Runner
  module_function
  def options
    @options ||=
    [['ruby options:'    , ''                                        ],
     ['-e, --eval LINE'                                               ,
      'Evaluate a LINE of code'                                      ],

     ['-d, --debug'                                                   ,
      'Set debugging flags (set $DEBUG to true)'                     ],

     ['-w, --warn'                                                    ,
       'Turn warnings on for your script (set $-w to true)'          ],

     ['-I, --include PATH'                                            ,
       'Specify $LOAD_PATH (may be used more than once)'             ],

     ['-r, --require LIBRARY'                                         ,
       'Require the library, before executing your script'           ],

     ['rib options:'     , ''                                        ],
     ['-c, --config FILE', 'Load config from FILE'                   ],
     ['-n, --no-config'  , 'Suppress loading ~/.config/rib/config.rb'],
     ['-h, --help'       , 'Print this message'                      ],
     ['-v, --version'    , 'Print the version'                       ]] +

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
    {'all'    => 'Load all recommended plugins'                ,
     'min'    => 'Run the minimum essence'                     ,
     'auto'   => 'Run as Rails or Ramaze console (auto-detect)',
     'rails'  => 'Run as Rails console'                        ,
     'ramaze' => 'Run as Ramaze console'                       }
  end

  # Extract the text below __END__ in the bin file as the description
  def command_descriptions_find path
    File.read(path) =~ /Gem\.bin_path\(['"](.+)['"], ['"](.+)['"],/
    File.read(Gem.bin_path($1, $2))[/\n__END__\n(.+)$/m, 1].strip
  end

  def run argv=ARGV
    (@running_commands ||= []) << Rib.config[:name]
    unused = parse(argv)
    # if it's running a Rib command, the loop would be inside Rib itself
    # so here we only parse args for the command
    return if @running_commands.pop != 'rib'
    # by comming to this line, it means now we're running Rib main loop,
    # not any other Rib command
    Rib.warn("Unused arguments: #{unused.inspect}") unless unused.empty?
    require 'rib/core' if Rib.config.delete(:mimic_irb)
    loop
  end

  def loop retry_times=5
    Rib.shell.loop
  rescue Exception => e
    if retry_times <= 0
      Rib.warn("Error: #{e}. Too many retries, give up.")
    else
      Rib.warn("Error: #{e}. Relaunching a new shell... ##{retry_times}")
      Rib.shells.pop
      Rib.shells << Rib::Shell.new(Rib.config)
      retry_times -= 1
      retry
    end
  end

  def parse argv
    unused = []
    until argv.empty?
      case arg = argv.shift
      when /^-e=?(.+)?/, /^--eval=?(.+)?/
        eval($1 || argv.shift, TOPLEVEL_BINDING, __FILE__, __LINE__)

      when /^-d/, '--debug'
        $DEBUG = true
        argv.unshift("-#{arg[2..-1]}") if arg.size > 2

      when /^-w/, '--warn'
        $-w, $VERBOSE = true, true
        argv.unshift("-#{arg[2..-1]}") if arg.size > 2

      when /^-I=?(.+)?/, /^--include=?(.+)?/
        paths = ($1 || argv.shift).split(':')
        $LOAD_PATH.unshift(*paths)

      when /^-r=?(.+)?/, /^--require=?(.+)?/
        require($1 || argv.shift)

      when /^-c=?(.+)?/, /^--config=?(.+)?/
        Rib.config[:config] = $1 || argv.shift

      when /^-n/, '--no-config'
        Rib.config.delete(:config)
        argv.unshift("-#{arg[2..-1]}") if arg.size > 2

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

  def help
    maxn = options.transpose.first.map(&:size).max
    maxd = options.transpose.last .map(&:size).max
    "Usage: #{Rib.config[:name]}"                    \
    " [ruby OPTIONS] [rib OPTIONS] [rib COMMANDS]\n" +
    options.map{ |(name, desc)|
      if desc.empty?
        name
      else
        sprintf("  %-*s  %-*s", maxn, name, maxd, desc)
      end
    }.join("\n")
  end

  def load_command command
    bin  = "rib-#{command}"
    path = `which #{bin}`.strip
    if path == ''
      Rib.warn(
        "Can't find #{bin} in $PATH. Please make sure it is installed,",
        "or is there any typo? You can try this to install it:\n"         ,
        "    gem install #{bin}")
    else
      Rib.config[:name] = bin
      load(path)
    end
  end
end
