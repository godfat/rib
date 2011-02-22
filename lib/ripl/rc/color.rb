
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::Color
  def format_result result
    colors = {
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

    case result
      when String ; send(colors[String      ]){ "'#{result}'"  }
      when Numeric; send(colors[Numeric     ]){ result         }
      when Symbol ; send(colors[Symbol      ]){ ":#{result}"   }
      when Array  ; send(colors[Array       ]){ '['            }  +
                    result.map{ |e| format_result(e) }.join(
                    send(colors[Array       ]){ ', '           }) +
                    send(colors[Array       ]){ ']'            }
      when Hash   ; send(colors[Hash        ]){ '{'            }  +
                    result.map{ |k, v| format_result(k)           +
                    send(colors[Hash        ]){ '=>'           }  +
                                       format_result(v) }.join(
                    send(colors[Hash        ]){ ', '           }) +
                    send(colors[Hash        ]){ '}'            }
      else        ; if colors[result.class]
                    send(colors[result.class]){ result.inspect }
                    else
                    send(colors[Object      ]){ result.inspect }
                    end
    end
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

Ripl::Shell.include(Ripl::Rc::Color)
