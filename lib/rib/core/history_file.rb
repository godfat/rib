
require 'rib'
require 'fileutils'

module Rib::HistoryFile
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    return super if HistoryFile.disabled?
    config[:history_file] ||= '~/.config/rib/history.rb'
    config[:history_size] ||= 500
    FileUtils.mkdir_p(File.dirname(history_file))
    super
  end

  def get_input
    return super if HistoryFile.disabled?
    (history << super).last
  end

  def read_history
    return super if HistoryFile.disabled?
    File.exist?(history_file) && history.empty? &&
      File.readlines(history_file).each{ |e| history << e.chomp }
  end

  def write_history
    return super if HistoryFile.disabled?
    File.open(history_file, 'w'){ |f|
      f.puts(history.to_a.last(config[:history_size]).join("\n")) }
  end

  private
  def history_file
    @history_file ||= File.expand_path(config[:history_file])
  end
end
