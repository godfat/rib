
require 'rib'
require 'fileutils'

module Rib::History
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    return super if History.disabled?
    config[:history]      ||= '~/.config/rib/history.rb'
    config[:history_size] ||= 500
    FileUtils.mkdir_p(File.dirname(history_file))
    read_history
    super
  end

  def after_loop
    return super if History.disabled?
    write_history
    super
  end

  def get_input
    (history << super).last
  end

  def read_history
    File.exist?(history_file) && history.empty? &&
      File.readlines(history_file).each{ |e| history << e.chomp }
  end

  def write_history
    File.open(history_file, 'w'){ |f|
      f.puts(history.to_a.last(config[:history_size]).join("\n")) }
  end

  def history
    @history ||= []
  end

  private
  def history_file
    @history_file ||= File.expand_path(config[:history])
  end
end
