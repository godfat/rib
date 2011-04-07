
require 'ripl/rc/u'

module Ripl::Rc::MkdirHistory
  include Ripl::Rc::U

  # ensure path existed
  def write_history
    return super if MkdirHistory.disabled?
    require 'fileutils'
    FileUtils.mkdir_p(File.dirname(history_file))
    super
  end
end

Ripl::Shell.include(Ripl::Rc::MkdirHistory)
