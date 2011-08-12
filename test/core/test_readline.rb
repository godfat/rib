
require 'rib/test'
require 'rib/core/readline'

shared :readline do
  should '#before_loop set @history' do
    @shell.history.should.eq Readline::HISTORY
  end

  should '#get_input calling Readline.readline' do
    mock(Readline).readline(@shell.prompt, true){'ok'}
    @shell.get_input.should.eq 'ok'
  end
end

describe Rib::Readline do
  behaves_like :rib

  before do
    @shell = Rib::Shell.new.before_loop
  end

  test_for Rib::Readline do
    behaves_like :readline
  end
end
