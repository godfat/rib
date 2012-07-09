
require 'rib/more/multiline_history'

module Rib::MultilineHistoryFile
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if MultilineHistoryFile.disabled?
    multiline_history_file_token
    super
  end

  # --------------- Plugin API ---------------

  def read_history
    return super if MultilineHistoryFile.disabled?
    buffer = []
    File.exist?(history_file_path) && history.empty? &&
      IO.readlines(history_file_path).each{ |line|
        if line.end_with?(
             "#{config[:multiline_history_file_token]}\n")
          buffer << line[0...
                         -multiline_history_file_token.size-1] + "\n"
        else
          history << (buffer.join + line).chomp
          buffer = []
        end
      }
  end

  def write_history
    return super if MultilineHistoryFile.disabled?
    # TODO: hisotroy.map is MRI 1.9+
    config[:history] = history.to_a.map{ |line|
      line.gsub("\n", "#{config[:multiline_history_file_token]}\n")
    }
    super
  end



  private
  def multiline_history_file_token
    config[:multiline_history_file_token] ||= ' '
  end
end
