
require 'rib/test'
require 'rib/core/readline'

copy :readline do
  would '#before_loop set @history' do
    @shell.history.should.eq Readline::HISTORY
  end

  would '#get_input calling Readline.readline' do
    mock(Readline).readline(@shell.prompt, true){'ok'}
    @shell.get_input.should.eq 'ok'
  end
end

describe Rib::Readline do
  paste :rib

  before do
    @shell = Rib::Shell.new.before_loop
  end

  test_for Rib::Readline do
    paste :readline
  end
end
