
require 'rib/test'
require 'rib/more/beep'

describe Rib::Beep do
  paste :rib

  before do
    Rib::Beep.enable
  end

  after do
    expect(Rib::Beep).disabled?
  end

  def verify delay, threshold=nil, &block
    new_shell(:started_at => Time.now - delay,
              :beep_threshold => threshold, &block)
  end

  def expect_beep shell
    mock(shell).print("\a"){}
  end

  def unexpect_beep shell
    stub(shell).print.with_any_args{ flunk }
  end

  describe 'beep' do
    would 'beep if loading too long' do
      verify(10, &method(:expect_beep))
    end

    would 'be configurable via beep_threshold' do
      verify(2, 1, &method(:expect_beep))
    end
  end

  describe 'not beep' do
    would 'not beep if not loading long' do
      verify(2, &method(:unexpect_beep))
    end

    would 'be configurable via beep_threshold' do
      verify(10, 15, &method(:unexpect_beep))
    end
  end
end
