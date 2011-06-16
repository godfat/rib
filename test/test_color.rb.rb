
require 'ripl/rc/test'
require 'ripl/rc/color'

describe Ripl::Rc::Color do
  should 'give correct color' do
    Ripl::Rc::Color.format_result(
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
