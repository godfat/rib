
require 'rib'
require 'fileutils'

module Rib::History
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    return super if History.disabled?
    history_file
    history_size
    FileUtils.mkdir_p(File.dirname(history_file_path))
    read_history
    Rib.say("History read from: #{history_file_path}") if $VERBOSE
    super
  end

  def after_loop
    return super if History.disabled?
    write_history
    Rib.say("History wrote to: #{history_file_path}") if $VERBOSE
    super
  end

  def get_input
    return super if History.disabled?
    (history << super).last
  end

  # --------------- Plugin API ---------------

  # The history data
  def history; config[:history] ||= []; end

  # Read config[:history_file] into #history, handled in history_file plugin
  def read_history
    return super if History.disabled?
    File.exist?(history_file_path) && history.empty? &&
      File.readlines(history_file_path).each{ |e| history << e.chomp }
  end

  # Write #history into config[:history_file], handled in history_file plugin
  def write_history
    return super if History.disabled?
    history_text = "#{history.to_a.last(history_size).join("\n")}\n"
    File.write(history_file_path, history_text)
  end



  private
  def history_file
    config[:history_file]      ||= File.join(Rib.home, 'history.rb')
  end

  def history_file_path
    config[:history_file_path] ||= File.expand_path(history_file)
  end

  def history_size
    config[:history_size] ||= 500
  end
end
