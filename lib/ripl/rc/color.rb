
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::Color
  def colors
    config[:rc_color]
  end

  def format_result result
    case result
      when String ; C.send(colors[String      ]){ "'#{result}'"  }
      when Numeric; C.send(colors[Numeric     ]){ result         }
      when Symbol ; C.send(colors[Symbol      ]){ ":#{result}"   }
      when Array  ; C.send(colors[Array       ]){ '['            }  +
                      result.map{ |e| format_result(e) }.join(
                    C.send(colors[Array       ]){ ', '           }) +
                    C.send(colors[Array       ]){ ']'            }
      when Hash   ; C.send(colors[Hash        ]){ '{'            }  +
                      result.map{ |k, v| format_result(k)           +
                    C.send(colors[Hash        ]){ '=>'           }  +
                                       format_result(v) }.join(
                    C.send(colors[Hash        ]){ ', '           }) +
                    C.send(colors[Hash        ]){ '}'            }
      else        ; if colors[result.class]
                    C.send(colors[result.class]){ result.inspect }
                    else
                    C.send(colors[Object      ]){ result.inspect }
                    end
    end
  end

  module C
    module_function
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
