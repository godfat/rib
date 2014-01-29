
require 'rib'

module Rib::Paging
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  # Print result if the it fits one screen,
  # paging it through a pager otherwise.
  def print_result result
    return super if Paging.disabled?
    output = format_result(result)
    if one_screen?(output)
      puts output
    else
      page_result(output)
    end
  rescue StandardError, SyntaxError => e
    Rib.warn("Error while printing result:\n  #{format_error(e)}")
  end

  # `less -F` can't cat the output, so we need to detect by ourselves.
  # `less -X` would mess up the buffers, so it's not desired, either.
  def one_screen? output
    cols, lines = `tput cols`.to_i, `tput lines`.to_i
    output.count("\n") <= lines &&
      output.gsub(/\e\[[^m]*m/, '').size <= cols * lines
  end

  def page_result output
    less = IO.popen(pager, 'w')
    less.write(output)
    less.close_write
  rescue Errno::EPIPE
    # less quit without consuming all the input
  end

  def pager
    ENV['PAGER'] || 'less -R'
  end
end

pager = ENV['PAGER'] || 'less'

if `which #{pager}`.empty?
  Rib.warn("#{pager} is not available, disabling Rib::Paging")
  Rib::Paging.disable
end
