
shared :setup_multiline do
  def setup_shell
    @shell = Rib::Shell.new(
      :binding => Object.new.instance_eval{binding}).before_loop
    stub(@shell).print
    stub(@shell).puts
  end

  def setup_input str
    if readline?
      mock(::Readline).readline(is_a(String), true){
        (::Readline::HISTORY << str.chomp)[-1]
      }
    else
      mock($stdin).gets{ str.chomp }
    end
  end

  def input str
    setup_input(str)
    mock.proxy(@shell).throw(:rib_multiline)
  end

  def input_done str, err=nil
    setup_input(str)
    if err
      mock(@shell).print_eval_error(is_a(err))
    else
      mock(@shell).print_result(is_a(Object))
    end
    @shell.loop_once
    true.should.eq true
  end
end

shared :multiline do
  before do
    setup_shell
  end

  should 'work with no prompt' do
    @shell.config[:prompt] = ''
    check <<-RUBY
      def f
        0
      end
    RUBY
  end

  should 'def f' do
    check <<-RUBY
      def f
        1
      end
    RUBY
  end

  should 'class C' do
    check <<-RUBY
      class C
      end
    RUBY
  end

  should 'begin' do
    check <<-RUBY
      begin
      end
    RUBY
  end

  should 'begin with RuntimeError' do
    check <<-RUBY, RuntimeError
      begin
        raise 'multiline raised an error'
      end
    RUBY
  end

  should 'do end' do
    check <<-RUBY
      [].each do
      end
    RUBY
  end

  should 'block brace' do
    check <<-RUBY
      [].each{
      }
    RUBY
  end

  should 'hash' do
    check <<-RUBY
      {
      }
    RUBY
  end

  should 'hash value' do
    check <<-RUBY
      {1 =>
       2}
    RUBY
  end

  should 'array' do
    check <<-RUBY
      [
      ]
    RUBY
  end

  should 'group' do
    check <<-RUBY
      (
      )
    RUBY
  end

  should 'string double quote' do
    check <<-RUBY
      "
      "
    RUBY
  end

  should 'string single quote' do
    check <<-RUBY
      '
      '
    RUBY
  end

  should 'be hash treated as a block SyntaxError' do
    check <<-RUBY, SyntaxError
      puts { :x => 10 }.class
    RUBY
  end

  should 'begin with SyntaxError' do
    check <<-RUBY, SyntaxError
      begin
        s-y n
    RUBY
  end

  should 'binary operator +' do
    check <<-RUBY
      1/1.to_i +
      1
    RUBY
  end

  should 'binary operator -' do
    check <<-RUBY
      1*1.to_i -
      1
    RUBY
  end

  should 'binary operator *' do
    check <<-RUBY
      1-1.to_i *
      1
    RUBY
  end

  should 'binary operator /' do
    check <<-RUBY
      1+1.to_i /
      1
    RUBY
  end

  should 'binary operator |' do
    check <<-RUBY
      1+1.to_i |
      1
    RUBY
  end

  should 'binary operator &' do
    check <<-RUBY
      1+1.to_i &
      1
    RUBY
  end

  should 'binary operator ^' do
    check <<-RUBY
      1+1.to_i ^
      1
    RUBY
  end
end
