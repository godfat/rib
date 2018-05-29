
require 'pork/auto'
require 'muack'

Pork::Suite.include(Muack::API)

require 'rib'

copy :rib do
  before do
    Rib.disable_plugins
  end

  after do
    Muack.verify
  end

  def shell opts={}
    @shell ||= new_shell(opts)
  end

  def new_shell opts={}
    result = Rib::Shell.new(
      {:binding => Object.new.instance_eval{binding}}.
      merge(opts))
    yield(result) if block_given?
    result.before_loop
  end

  def stub_output
    stub(shell).print(is_a(String)){}
    stub(shell).puts(is_a(String)){}
    stub(shell).puts{}
  end

  def readline?
    Rib.constants.map(&:to_s).include?('Readline') &&
      Rib::Readline.enabled?
  end

  def stub_readline meth=:stub
    send(meth, ::Readline).readline(is_a(String), true) do
      (::Readline::HISTORY << str.chomp).last
    end
  end

  singleton_class.module_eval do
    def test_for *plugins, &block
      require 'rib/all' # exhaustive tests
      rest = Rib.plugins - plugins

      before do
        Rib.enable_plugins(plugins)
        Rib.disable_plugins(rest)
      end

      describe "enabling #{plugins}" do
        block.call

        case ENV['TEST_LEVEL']
        when '0'
        when '1'
          test_level1(rest, block)
        when '2'
          test_level2(rest, block)
        when '3'
          test_level3(rest, block)
        else # test_level3 is too slow because of rr (i guess)
          test_level2(rest, block)
        end
      end
    end

    def test_level1 rest, block
      rest.each{ |target|
        target.enable

        describe "also enabling #{target}" do
          block.call
        end

        target.disable
      }
    end

    def test_level2 rest, block
      rest.combination(2).each{ |targets|
        Rib.enable_plugins(targets)

        describe "also enabling #{targets.join(', ')}" do
          block.call
        end

        Rib.disable_plugins(targets)
      }
    end

    def test_level3 rest, block
      if rest.empty?
        block.call
      else
        rest[0].enable

        describe "also enabling #{rest[0]}" do
          test_level3(rest[1..-1], block)
        end

        rest[0].disable

        describe "disabling #{rest[0]}" do
          test_level3(rest[1..-1], block)
        end
      end
    end
  end
end

def main
  'rib'
end

Rib::Blackhole = Object.new
b = Rib::Blackhole.singleton_class
b.instance_methods(true).each{ |m|
  b.send(:undef_method, m) unless
    [:object_id, :__send__, :__id__].include?(m) }
