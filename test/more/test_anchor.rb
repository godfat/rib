
require 'rib/test'
require 'rib/more/anchor'
require 'rib/core/multiline'
require 'rib/test/multiline'

describe Rib::Anchor do
  paste :rib
  paste :setup_multiline

  before do
    Rib::Anchor.enable
  end

  describe '#anchor?' do
    would 'give true when anchoring' do
      stub(Rib).shell{shell}

      mock(shell).get_input do
        expect(shell).anchor?

        mock(shell).puts{}

        nil
      end

      Rib.anchor 'test'
    end

    would 'give false when not anchoring' do
      expect(new_shell).not.anchor?
    end
  end

  describe '.stop_anchors' do
    def anchor_deeper shell, index
      mock(shell).get_input do
        mock(shell).puts.times(0)

        expect(shell).anchor?
        expect(shell.loop_eval('self')).eq index

        mock_deeper(index + 1)
        'Rib.anchor self + 1'
      end
    end

    def escape shell
      mock(shell).get_input do
        'Rib.stop_anchors'
      end
    end

    def mock_deeper index
      mock(Rib).shell.times(2) # ignore first 2 calls, see Rib.anchor
      mock(Rib).shell.peek_return do |deeper_shell|
        if index < 5
          anchor_deeper(deeper_shell, index)
        else
          escape(deeper_shell)
        end

        deeper_shell
      end
    end

    would 'exit all anchors' do
      shell = Rib.shell

      mock(shell).get_input do
        mock_deeper(0)
        'Rib.anchor 0'
      end

      mock(shell).get_input{}
      mock(shell).puts{}

      shell.loop
    end
  end

  test_for Rib::Anchor, Rib::Multiline do
    paste :multiline
  end
end
