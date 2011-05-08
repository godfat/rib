
require 'ripl/rc/u'
# require 'ripl/rc/history_ivar' # dependency

module Ripl::Rc::MultilineHistoryFile
  include Ripl::Rc::U

  def write_history
    return super if MultilineHistoryFile.disabled?
    @history = history.to_a.map{ |line|
      line.gsub("\n", "#{Ripl.config[:rc_multiline_history_file_token]}\n")
    }
    super
  end

  def before_loop
    return super if MultilineHistoryFile.disabled?
    super # this would initilaize @history to [], nothing we can do here
    buffer = []
    File.exist?(history_file) &&
      IO.readlines(history_file).each{ |line|
        if line.end_with?(
             "#{Ripl.config[:rc_multiline_history_file_token]}\n")
          buffer << line[0...
               -Ripl.config[:rc_multiline_history_file_token].size-1] + "\n"
        else
          history << (buffer.join + line).chomp
          buffer = []
        end
      }
  end
end

Ripl::Shell.include(Ripl::Rc::MultilineHistoryFile)
Ripl.config[:rc_multiline_history_file_token] ||= ' '
