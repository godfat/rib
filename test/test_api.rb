
require 'rib/test'
require 'rib/shell'

describe Rib::Shell::API do
  behaves_like :rib

  Rib::Shell::API.instance_methods.delete_if{ |e| e[/=$/] }.each do |meth|
    should "##{meth} be accessible to plugins" do
      mod = Object.const_set "Ping_#{meth}", Module.new
      mod.send(:define_method, meth) { "pong_#{meth}" }
      shell = Rib::Shell.dup
      shell.use(mod)
      shell.new.send(meth).should == "pong_#{meth}"
    end
  end
end
