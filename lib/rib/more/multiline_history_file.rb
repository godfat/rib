
require 'rib/more/multiline_history'

module Rib::MultilineHistoryFile
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    return super if MultilineHistoryFile.disabled?
    config[:multiline_history_file_token] ||= ' '
    super
  end

  def read_history
    return super if MultilineHistoryFile.disabled?
    buffer = []
    File.exist?(history_file) && history.empty? &&
      IO.readlines(history_file).each{ |line|
        if line.end_with?(
             "#{config[:multiline_history_file_token]}\n")
          buffer << line[0...
               -config[:multiline_history_file_token].size-1] + "\n"
        else
          history << (buffer.join + line).chomp
          buffer = []
        end
      }
  end

  def write_history
    return super if MultilineHistoryFile.disabled?
    config[:history] = history.to_a.map{ |line|
      line.gsub("\n", "#{config[:multiline_history_file_token]}\n")
    }
    super
  end
end
