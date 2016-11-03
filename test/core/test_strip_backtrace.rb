
require 'rib/test'
require 'rib/core/strip_backtrace'

describe Rib::StripBacktrace do
  would 'strip home' do
    backtrace = ["#{ENV['HOME']}/test", "/prefix/#{ENV['HOME']}/test"]

    expect(Rib::StripBacktrace.strip_home_backtrace(backtrace)).
      eq ['~/test', "/prefix/#{ENV['HOME']}/test"]
  end

  would 'strip current working directory' do
    backtrace = [File.expand_path(__FILE__)]

    expect(Rib::StripBacktrace.strip_cwd_backtrace(backtrace)).
      eq ['test/core/test_strip_backtrace.rb']
  end
end
