
require 'ripl'

module Ripl::Rc
  module U
    module_function
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

module Ripl::Rc::Color
  include Ripl::Rc

  def format_result result
    case result
      when String ; U.send(U.colors[String      ]){ "'#{result}'"  }
      when Numeric; U.send(U.colors[Numeric     ]){ result         }
      when Symbol ; U.send(U.colors[Symbol      ]){ ":#{result}"   }
      when Array  ; U.send(U.colors[Array       ]){ '['            }  +
                      result.map{ |e| format_result(e) }.join(
                    U.send(U.colors[Array       ]){ ', '           }) +
                    U.send(U.colors[Array       ]){ ']'            }
      when Hash   ; U.send(U.colors[Hash        ]){ '{'            }  +
                      result.map{ |k, v| format_result(k)             +
                    U.send(U.colors[Hash        ]){ '=>'           }  +
                                       format_result(v) }.join(
                    U.send(U.colors[Hash        ]){ ', '           }) +
                    U.send(U.colors[Hash        ]){ '}'            }
      else        ; if U.colors[result.class]
                    U.send(U.colors[result.class]){ result.inspect }
                    else
                    U.send(U.colors[Object      ]){ result.inspect }
                    end
    end
  end
end

Ripl::Shell.include(Ripl::Rc::Color)
Ripl.config[:rc_color] ||= {
  String     => :green  ,
  Numeric    => :red    ,
  Symbol     => :cyan   ,
  Array      => :blue   ,
  Hash       => :blue   ,
  NilClass   => :magenta,
  TrueClass  => :magenta,
  FalseClass => :magenta,
  Object     => :yellow
}
