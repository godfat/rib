
shared :multiline do
  before do
    Rib::Multiline.enable
    setup_shell
  end

  def setup_shell
    @shell = Rib::Shell.new(
      :binding => Object.new.instance_eval{binding}).before_loop
    stub(@shell).print
  end

  def input str
    mock($stdin).gets{ str }
    mock.proxy(@shell).throw(:rib_multiline)
  end

  def input_done str
    mock($stdin).gets{ str }
    mock(@shell).print_result(anything)
    @shell.loop_once.should.eq @shell
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
