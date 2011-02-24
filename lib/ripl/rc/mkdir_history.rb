
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::MkdirHistory
  # ensure path existed
  def write_history
    require 'fileutils'
    FileUtils.mkdir_p(File.dirname(history_file))
    super
  end
end

Ripl::Shell.include(Ripl::Rc::MkdirHistory)
