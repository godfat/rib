
require 'ripl/rc/test'
require 'ripl/rc'

describe Ripl::Rc::U do
  before do
    @names = Dir[File.expand_path(
               "#{File.dirname(__FILE__)}/../lib/ripl/rc/*.rb")].
               map   {|path| File.basename(path)[0..-4]                     }.
               reject{|name| %w[version u noirbrc test debug].include?(name)}
    @mods  = Ripl::Shell.ancestors[1..-1].select{ |mod| mod < Ripl::Rc }
  end

  after do
    @mods.each(&:enable)
  end

  should 'have shortcut methods' do
    @names.each{ |name|
      %w[enable disable].each{ |meth|
        Ripl.should.respond_to?("#{meth}_#{name}") == true
      }
      %w[enabled? disabled?].each{ |meth|
        Ripl.should.respond_to?("#{name}_#{meth}") == true
      }
    }
  end

  should 'be the same as mod methods' do
    @mods.shuffle.take(@mods.size/2).each(&:disable)
    @names.each{ |name|
      %w[enabled? disabled?].each{ |meth|
        Ripl.send("#{name}_#{meth}").should ==
          @mods.find{ |mod|
            mod.name[/::\w+$/].tr(':', '') ==
            name.gsub(/([^_]+)/){$1.capitalize}.tr('_', '') }.
          send(meth)
      }
    }
  end
end
