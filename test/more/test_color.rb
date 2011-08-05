
require 'rib/test'
require 'rib/more/color'

describe Rib::Color do
  before do
    @color = Class.new do
      include Rib::Color
      def colors
        @colors ||= Rib::Shell.new.before_loop.config[:color]
      end
    end.new
  end

  should 'give correct color' do
    @color.send(:format_color,
      [{0 => :a}, 'b', [nil, {false => Object}], {true => Exception.new}]).
        should ==
          "\e[34m[\e[m\e[34m{\e[m\e[31m0\e[m\e[34m=>\e[m\e[36m:a\e[m\e[" \
          "34m}\e[m\e[34m, \e[m\e[32m\"b\"\e[m\e[34m, \e[m\e[34m[\e[m\e" \
          "[35mnil\e[m\e[34m, \e[m\e[34m{\e[m\e[35mfalse\e[m\e[34m=>\e[" \
          "m\e[33mObject\e[m\e[34m}\e[m\e[34m]\e[m\e[34m, \e[m\e[34m{\e" \
          "[m\e[35mtrue\e[m\e[34m=>\e[m\e[35m#<Exception: Exception>\e[" \
          "m\e[34m}\e[m\e[34m]\e[m"
  end
end
