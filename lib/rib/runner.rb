
require 'rib'

module Rib::Runner
  module_function
  def options
    [['ruby options:', '']                                            ,
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

     ['rib options:', '']                                             ,
     ['-c, --config FILE', 'Load config from FILE'                   ],
     ['-n, --no-config'  , 'Suppress loading ~/.config/rib/config.rb'],
     ['-h, --help'       , 'Print this message'                      ],
     ['-v, --version'    , 'Print the version'                       ]]
  end

  def run argv=ARGV
    (@commands ||= []) << Rib.config[:name]
    unused = parse(argv)
    # if it's running a Rib command, the loop would be inside Rib itself
    # so here we only parse args for the command
    return if @commands.pop != 'rib'
    # by comming to this line, it means now we're running Rib main loop,
    # not any other Rib command
    Rib.warn("Unused arguments: #{unused.inspect}") unless unused.empty?
    Rib.shell.loop
  end

  def parse argv
    unused = []
    until argv.empty?
      case arg = argv.shift
      when /-e=?(.+)?/, /--eval=?(.+)?/
        eval($1 || argv.shift, binding, __FILE__, __LINE__)

      when '-d', '--debug'
        $DEBUG = true

      when '-w', '--warn'
        $-w = true

      when /-I=?(.+)?/, /--include=?(.+)?/
        paths = ($1 || argv.shift).split(':')
        $LOAD_PATH.unshift(*paths)

      when /-r=?(.+)?/, /--require=?(.+)?/
        require($1 || argv.shift)

      when /-c=?(.+)?/, /--config=?(.+)?/
        Rib.config[:config] = $1 || argv.shift

      when '-n', '--no-config'
        Rib.config.delete(:config)

      when '-h', '--help'
        puts(help)
        exit

      when '-v', '--version'
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
    name = Rib.config[:name]
    maxn = options.transpose.first.map(&:size).max
    maxd = options.transpose.last .map(&:size).max
    "Usage: #{name} [ruby OPTIONS] [rib COMMAND] [rib OPTIONS]\n" +
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
