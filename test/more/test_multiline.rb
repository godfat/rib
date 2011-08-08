
require 'rib/test'
require 'rib/more/multiline'

describe Rib::Multiline do
  behaves_like :rib

  before do
    Rib::Multiline.enable
    @shell = Rib::Shell.new.before_loop
  end

  def input str
    mock(      @shell).get_input{ str }
    mock.proxy(@shell).throw(:rib_multiline)
  end

  def input_done str
    mock(@shell).get_input{ str }
    mock(@shell).print_result(anything)
    @shell.loop_once.should.eq @shell
  end

  def test str
    lines = str.split("\n")
    lines[0...-1].each{ |line|
      input(line)
      @shell.loop_once
    }
    input_done(lines.last)
  end

  should 'def f' do
    test <<-RUBY
      def f
        1
      end
    RUBY
  end

  should 'class C' do
    test <<-RUBY
      class C
      end
    RUBY
  end

  should 'begin' do
    test <<-RUBY
      begin
      end
    RUBY
  end

  should 'do end' do
    test <<-RUBY
      [].each do
      end
    RUBY
  end

  should 'block brace' do
    test <<-RUBY
      [].each{
      }
    RUBY
  end

  should 'hash' do
    test <<-RUBY
      {
      }
    RUBY
  end

  should 'hash value' do
    test <<-RUBY
      {1 =>
       2}
    RUBY
  end

  should 'array' do
    test <<-RUBY
      [
      ]
    RUBY
  end

  should 'group' do
    test <<-RUBY
      (
      )
    RUBY
  end

  should 'string double quote' do
    test <<-RUBY
      "
      "
    RUBY
  end

  should 'string single quote' do
    test <<-RUBY
      '
      '
    RUBY
  end
end
