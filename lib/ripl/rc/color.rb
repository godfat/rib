
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::Color
  include Ripl::Rc # makes U avaliable

  def format_result result, display=result.inspect
    case result
      when String ; U.send(U.colors[String      ]){ display }
      when Numeric; U.send(U.colors[Numeric     ]){ display }
      when Symbol ; U.send(U.colors[Symbol      ]){ display }

      when Array  ; U.send(U.colors[Array       ]){ '['     }  +
                      result.map{ |e| format_result(e) }.join(
                    U.send(U.colors[Array       ]){ ', '    }) +
                    U.send(U.colors[Array       ]){ ']'     }

      when Hash   ; U.send(U.colors[Hash        ]){ '{'     }  +
                      result.map{ |k, v| format_result(k)      +
                    U.send(U.colors[Hash        ]){ '=>'    }  +
                                       format_result(v) }.join(
                    U.send(U.colors[Hash        ]){ ', '    }) +
                    U.send(U.colors[Hash        ]){ '}'     }

      # TODO: this find should preserve order!
      else        ; if pair = U.colors.find{|klass, _|result.kind_of?(klass)}
                    U.send(pair.last){ display }
                    else
                    U.send(U.colors[Object      ]){ display }
                    end
    end
  end

  def get_error e, backtrace=e.backtrace
    [format_result(e, "#{e.class.to_s}: #{e.message}"),
     backtrace.map{ |b|
       path, rest = File.split(b)
       name, msgs = rest.split(':', 2)
       msg = msgs.sub(/(\d+):/){U.red{$1}+':'}.sub(/`.+?'/){U.green{$&}}

       "#{path+'/'}#{U.yellow{name}}:#{msg}"
     }]
  end

  module Imp
    def colors
      Ripl.config[:rc_color]
    end

    def color rgb
      "\x1b[#{rgb}m" + (block_given? ? "#{yield}#{reset}" : '')
    end

    def   black &block; color(30, &block); end
    def     red &block; color(31, &block); end
    def   green &block; color(32, &block); end
    def  yellow &block; color(33, &block); end
    def    blue &block; color(34, &block); end
    def magenta &block; color(35, &block); end
    def    cyan &block; color(36, &block); end
    def   white &block; color(37, &block); end
    def   reset &block; color('', &block); end
  end
end

module Ripl::Rc::U; extend Ripl::Rc::Color::Imp; end

Ripl::Shell.include(Ripl::Rc::Color)
Ripl.config[:rc_color] ||= {
  Numeric    => :red    ,
  String     => :green  ,
  Symbol     => :cyan   ,
  Array      => :blue   ,
  Hash       => :blue   ,
  NilClass   => :magenta,
  TrueClass  => :magenta,
  FalseClass => :magenta,
  Exception  => :magenta,
  Object     => :yellow
}
