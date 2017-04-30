
require 'rib/test'
require 'rib/more/color'

describe Rib::Color do
  paste :rib

  before do
    Rib::Color.enable
  end

  color = Class.new do
    include Rib::Color
    def colors
      @colors ||= Rib::Shell.new.before_loop.config[:color]
    end

    def inspect_result result
      result.inspect
    end
  end.new

  would 'give correct color' do
    color.send(:format_color,
      [{0 => :a}, 'b', [nil, {false => Object}], {true => Exception.new}]).
        should.eq \
          "\e[34m[\e[0m\e[34m{\e[0m\e[31m0\e[0m\e[34m=>\e[0m\e[36m:a\e[0m\e" \
          "[34m}\e[0m\e[34m, \e[0m\e[32m\"b\"\e[0m\e[34m, \e[0m\e[34m[\e[0m" \
          "\e[35mnil\e[0m\e[34m, \e[0m\e[34m{\e[0m\e[35mfalse\e[0m\e[34m=>"  \
          "\e[0m\e[33mObject\e[0m\e[34m}\e[0m\e[34m]\e[0m\e[34m, \e[0m\e[34m"\
          "{\e[0m\e[35mtrue\e[0m\e[34m=>\e[0m\e[35m#<Exception: Exception>"  \
          "\e[0m\e[34m}\e[0m\e[34m]\e[0m"
  end

  would 'inspect recursive array and hash just like built-in inspect' do
    a = []
    a << a
    h = {}
    h[0] = h
    color.send(:format_color, [a, h]).should.eq \
      "\e[34m[\e[0m\e[34m[\e[0m\e[34m[...]\e[0m\e[34m]\e[0m\e[34m, \e[0m" \
      "\e[34m{\e[0m\e[31m0\e[0m\e[34m=>\e[0m\e[34m{...}\e[0m\e[34m}\e[0m" \
      "\e[34m]\e[0m"
  end

  # regression test
  would "colorize errors with `/' inside" do
    error = Class.new(Exception)

    begin
      line = __LINE__; raise error
    rescue error => e
      msg = "test/more/#{Rib::Color.yellow{'test_color.rb'}}:" \
            "#{Rib::Color.red{line}}:in #{Rib::Color.green}"
      Rib::Color.colorize_backtrace(e.backtrace).first.should =~ \
        Regexp.new(
          "#{Regexp.escape(msg)}`.+'#{Regexp.escape(Rib::Color.reset)}")
    end
  end

  would 'colorize warnings' do
    shell = new_shell

    shell.warn('test')

    expect(shell.warnings).eq ["\e[31mtest\e[0m"]
  end
end
