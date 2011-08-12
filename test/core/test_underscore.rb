
require 'rib/test'
require 'rib/core/underscore'

shared :underscore do
  should 'set _' do
    setup
    mock(@shell).get_input{'_'}
    mock(@shell).get_input{'10**2'}
    mock(@shell).get_input{'_'}
    @shell.loop_once.should.eq [nil, nil]
    @shell.loop_once
    @shell.loop_once.should.eq [100, nil]
  end

  should 'not set _ if already there' do
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

  should 'set __' do
    setup
    stub(@shell).puts
    mock(@shell).get_input{'XD'}
    mock(@shell).get_input{'__'}
    @shell.loop_once
    @shell.loop_once.first.should.kind_of?(NameError)
  end
end

describe Rib::Underscore do
  behaves_like :rib

  def setup bound=Object.new
    @shell = Rib::Shell.new(
      :binding => bound.instance_eval{binding}).before_loop
    stub(@shell).puts
  end

  test_for Rib::Underscore do
    behaves_like :underscore
  end
end
