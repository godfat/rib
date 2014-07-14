
require 'rib/test'
require 'rib/all'

describe Rib::Plugin do
  paste :rib

  before do
    @names = Dir[File.expand_path(
               "#{File.dirname(__FILE__)}/../lib/rib/{core,more,zore}/*.rb")].
               map   {|path| File.basename(path)[0..-4]                     }
    @mods  = Rib.plugins
  end

  would 'have shortcut methods' do
    @names.each{ |name|
      %w[enable disable].each{ |meth|
        Rib.respond_to?("#{meth}_#{name}").should == true
      }
      %w[enabled? disabled?].each{ |meth|
        Rib.respond_to?("#{name}_#{meth}").should == true
      }
    }
  end

  would 'be the same as mod methods' do
    @mods.shuffle.take(@mods.size/2).each(&:disable)
    @names.each{ |name|
      %w[enabled? disabled?].each{ |meth|
        Rib.send("#{name}_#{meth}").should ==
          @mods.find{ |mod|
            mod.name[/::\w+$/].tr(':', '') ==
            name.gsub(/([^_]+)/){$1.capitalize}.tr('_', '') }.
          send(meth)
      }
    }
  end
end
