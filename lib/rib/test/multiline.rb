
copy :setup_multiline do
  def setup_shell
    @shell = new_shell
    stub(@shell).print{}.with_any_args
    stub(@shell).puts{} .with_any_args
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
    mock(@shell).throw(:rib_multiline)
  end

  def input_done str, err=nil
    setup_input(str)
    if err
      mock(@shell).print_eval_error(is_a(err)){}
    else
      mock(@shell).print_result(is_a(Object)){}
    end
    @shell.loop_once
    ok
  end

  def check str, err=nil
    lines = str.split("\n")
    lines[0...-1].each{ |line|
      input(line)
      @shell.loop_once
    }
    input_done(lines.last, err)
  end
end

copy :multiline do
  before do
    setup_shell
  end

  would 'work with no prompt' do
    @shell.config[:prompt] = ''
    check <<-RUBY
      def f
        0
      end
    RUBY
  end

  would 'def f' do
    check <<-RUBY
      def f
        1
      end
    RUBY
  end

  would 'class C' do
    check <<-RUBY
      class C
      end
    RUBY
  end

  would 'begin' do
    check <<-RUBY
      begin
      end
    RUBY
  end

  would 'begin with RuntimeError' do
    check <<-RUBY, RuntimeError
      begin
        raise 'multiline raised an error'
      end
    RUBY
  end

  would 'do end' do
    check <<-RUBY
      [].each do
      end
    RUBY
  end

  would 'block brace' do
    check <<-RUBY
      [].each{
      }
    RUBY
  end

  would 'hash' do
    check <<-RUBY
      {
      }
    RUBY
  end

  would 'hash value' do
    check <<-RUBY
      {1 =>
       2}
    RUBY
  end

  would 'array' do
    check <<-RUBY
      [
      ]
    RUBY
  end

  would 'group' do
    check <<-RUBY
      (
      )
    RUBY
  end

  would 'string double quote' do
    check <<-RUBY
      "
      "
    RUBY
  end

  would 'string single quote' do
    check <<-RUBY
      '
      '
    RUBY
  end

  would 'be hash treated as a block SyntaxError' do
    check <<-RUBY, SyntaxError
      puts { :x => 10 }.class
    RUBY
  end

  would 'begin with SyntaxError' do
    check <<-RUBY, SyntaxError
      begin
        s-y n
    RUBY
  end

  would 'binary operator +' do
    check <<-RUBY
      1/1.to_i +
      1
    RUBY
  end

  would 'binary operator -' do
    check <<-RUBY
      1*1.to_i -
      1
    RUBY
  end

  would 'binary operator *' do
    check <<-RUBY
      1-1.to_i *
      1
    RUBY
  end

  would 'binary operator /' do
    check <<-RUBY
      1+1.to_i /
      1
    RUBY
  end

  would 'binary operator |' do
    check <<-RUBY
      1+1.to_i |
      1
    RUBY
  end

  would 'binary operator &' do
    check <<-RUBY
      1+1.to_i &
      1
    RUBY
  end

  would 'binary operator ^' do
    check <<-RUBY
      1+1.to_i ^
      1
    RUBY
  end
end
