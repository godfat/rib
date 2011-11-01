
require 'rib/test'
require 'rib/more/color'

describe Rib::Color do
  behaves_like :rib

  should 'give correct color' do
    @color = Class.new do
      include Rib::Color
      def colors
        @colors ||= Rib::Shell.new.before_loop.config[:color]
      end
    end.new

    @color.send(:format_color,
      [{0 => :a}, 'b', [nil, {false => Object}], {true => Exception.new}]).
        should.eq \
          "\e[34m[\e[0m\e[34m{\e[0m\e[31m0\e[0m\e[34m=>\e[0m\e[36m:a\e[0m\e" \
          "[34m}\e[0m\e[34m, \e[0m\e[32m\"b\"\e[0m\e[34m, \e[0m\e[34m[\e[0m" \
          "\e[35mnil\e[0m\e[34m, \e[0m\e[34m{\e[0m\e[35mfalse\e[0m\e[34m=>"  \
          "\e[0m\e[33mObject\e[0m\e[34m}\e[0m\e[34m]\e[0m\e[34m, \e[0m\e[34m"\
          "{\e[0m\e[35mtrue\e[0m\e[34m=>\e[0m\e[35m#<Exception: Exception>"  \
          "\e[0m\e[34m}\e[0m\e[34m]\e[0m"
  end

  # regression test
  should "colorize errors with `/' inside" do
    begin
      line = __LINE__; 1/0
    rescue ZeroDivisionError => e
      Rib::Color.colorize_backtrace(e.backtrace).first.should.eq \
        "test/more/#{Rib::Color.yellow{'test_color.rb'}}:" \
        "#{Rib::Color.red{line}}:in #{Rib::Color.green{"`/'"}}"
    end
  end
end
