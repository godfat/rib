
require 'rib/test'
require 'rib/core/underscore'

copy :underscore do
  would 'set _' do
    setup
    mock(@shell).get_input{'_'}
    mock(@shell).get_input{'10**2'}
    mock(@shell).get_input{'_'}
    @shell.loop_once.should.eq [nil, nil]
    @shell.loop_once
    @shell.loop_once.should.eq [100, nil]
  end

  would 'not set _ if already there' do
    bound = Object.new
    def bound._
      'hey'
    end
    setup(bound)
    mock(@shell).get_input{'_'}
    mock(@shell).get_input{'10**2'}
    mock(@shell).get_input{'_'}
    @shell.loop_once.should.eq ['hey', nil]
    @shell.loop_once
    @shell.loop_once.should.eq ['hey', nil]
  end

  would 'set __' do
    setup
    stub(@shell).puts{}.with_any_args
    mock(@shell).get_input{'XD'}
    mock(@shell).get_input{'__'}
    @shell.loop_once
    @shell.loop_once.first.should.kind_of?(NameError)
  end
end

describe Rib::Underscore do
  paste :rib

  def setup bound=Object.new
    @shell = Rib::Shell.new(
      :binding => bound.instance_eval{binding}).before_loop
    stub(@shell).puts(is_a(String)){}
  end

  test_for Rib::Underscore do
    paste :underscore
  end
end
