
module Ripl::Rc::StripBacktrace
  # strip backtrace until ripl
  def format_error e
    "#{e.class}: #{e.message}\n  #{strip_backtrace(e).join("\n  ")}"
  end

  def strip_backtrace e
    e.backtrace[0..e.backtrace.rindex{ |l| l =~ /\(ripl\):\d+:in `.+?'/ }]
  end
end

Ripl::Shell.include(Ripl::Rc::StripBacktrace)
