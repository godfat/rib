
# upon session ends
require 'ripl/rc/squeeze_history'
require 'ripl/rc/mkdir_history'
require 'ripl/rc/ctrld_newline'

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
Ripl.shell
