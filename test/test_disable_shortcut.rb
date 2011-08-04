
require 'rib/test'
require 'rib/all'

describe Rib::Plugin do
  before do
    @names = Dir[File.expand_path(
               "#{File.dirname(__FILE__)}/../lib/rib/{core,more,zore}/*.rb")].
               map   {|path| File.basename(path)[0..-4]                     }
    @mods  = Rib::Shell.ancestors[1..-1].select{ |mod| mod < Rib::Plugin }
  end

  after do
    @mods.each(&:enable)
  end

  should 'have shortcut methods' do
    @names.each{ |name|
      %w[enable disable].each{ |meth|
        Rib.should.respond_to?("#{meth}_#{name}") == true
      }
      %w[enabled? disabled?].each{ |meth|
        Rib.should.respond_to?("#{name}_#{meth}") == true
      }
    }
  end

  should 'be the same as mod methods' do
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
