
require 'rib/test'
require 'rib/shell'

describe Rib::API do
  paste :rib

  Rib::API.instance_methods.delete_if{ |e| e[/=$/] }.each do |meth|
    would "##{meth} be accessible to plugins" do
      mod = Module.new do
        define_method meth do
          "pong_#{meth}"
        end
      end
      klass = Rib::Shell.dup
      klass.use(mod)

      expect(klass.new.send(meth)).eq "pong_#{meth}"
    end
  end

  would 'emit a warning whenever result is not a string' do
    object = Class.new{ alias_method :inspect, :object_id }.new

    mock(shell).get_input{'object'}
    mock(shell).loop_eval('object'){object}
    mock(shell).puts("=> #{object.object_id}"){}
    mock($stderr).puts(including("#{object.class}#inspect")){}

    shell.loop_once

    ok
  end

  describe '#warn' do
    would 'append a warning message to warnings' do
      shell.warn('test')

      expect(shell.warnings).eq ['test']
    end
  end

  describe '#flush_warnings' do
    before do
      shell.warn('test')

      mock($stderr).puts('rib: test'){}
    end

    would 'warn to $stderr from #warnings' do
      shell.flush_warnings

      ok
    end
  end
end
