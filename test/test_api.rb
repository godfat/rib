
require 'rib/test'
require 'rib/shell'

describe Rib::API do
  behaves_like :rib

  Rib::API.instance_methods.delete_if{ |e| e[/=$/] }.each do |meth|
    should "##{meth} be accessible to plugins" do
      mod = Module.new do
        define_method meth do
          "pong_#{meth}"
        end
      end
      shell = Rib::Shell.dup
      shell.use(mod)
      shell.new.send(meth).should == "pong_#{meth}"
    end
  end
end
