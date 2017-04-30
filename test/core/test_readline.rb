
require 'rib/test'
require 'rib/core/readline'

describe Rib::Readline do
  paste :rib

  test_for Rib::Readline do
    would '#before_loop set @history' do
      expect(shell.history).eq Readline::HISTORY
    end

    would '#get_input calling Readline.readline' do
      mock(Readline).readline(shell.prompt, true){'ok'}

      expect(shell.get_input).eq 'ok'
    end
  end
end
