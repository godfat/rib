
# this really messes thing up! should be loaded first if we're using
# ripl/rc/multiline_history_file, otherwise, history couldn't really
# be overridden...
require 'ripl'
if Ripl.config[:readline] == true
  require 'readline'
  require 'ripl/readline'
elsif Ripl.config[:readline]
  require Ripl.config[:readline].to_s
  require 'ripl/readline'
end

# upon session ends
require 'ripl/rc/squeeze_history'
require 'ripl/rc/multiline_history_file'
require 'ripl/rc/mkdir_history'
require 'ripl/rc/ctrld_newline'
require 'ripl/rc/ensure_after_loop'

# upon exception occurs
require 'ripl/rc/last_exception'

# upon formatting output
require 'ripl/rc/strip_backtrace'
require 'ripl/rc/color'

# upon input
require 'ripl/rc/multiline'
require 'ripl/rc/multiline_history'
require 'ripl/rc/eat_whites'

# speical tool
require 'ripl/rc/anchor'

# about config
require 'ripl/rc/noirbrc'

# to force ripl to load everything before bundler kicks in!
(Ripl.config[:rc_shells] ||= []) << Ripl.shell
