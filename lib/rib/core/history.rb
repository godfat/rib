
require 'rib'
require 'fileutils'

module Rib::History
  include Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if History.disabled?
    config[:history_file] ||= '~/.config/rib/history.rb'
    config[:history_size] ||= 500
    FileUtils.mkdir_p(File.dirname(history_file_path))
    read_history
    super
  end

  def after_loop
    return super if History.disabled?
    write_history
    super
  end

  def get_input
    return super if History.disabled?
    (history << super).last
  end

  # --------------- Plugin API ---------------

  # The history data
  def history; config[:history] ||= []; end

  protected
  # Read config[:history_file] into #history, handled in history_file plugin
  def read_history
    return super if History.disabled?
    File.exist?(history_file_path) && history.empty? &&
      File.readlines(history_file_path).each{ |e| history << e.chomp }
  end

  # Write #history into config[:history_file], handled in history_file plugin
  def write_history
    return super if History.disabled?
    File.open(history_file_path, 'w'){ |f|
      f.puts(history.to_a.last(config[:history_size]).join("\n")) }
  end

  def history_file_path
    config[:history_file_path] ||= File.expand_path(config[:history_file])
  end
end
