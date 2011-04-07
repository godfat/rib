
require 'bacon'
require 'rr'
require 'ripl/rc'
Bacon.summary_on_exit
include RR::Adapters::RRMethods

describe Ripl::Rc::U do
  should 'have shortcut methods' do
    mods = Dir[File.expand_path(
                 "#{File.dirname(__FILE__)}/../lib/ripl/rc/*.rb")].
                 map   { |path| File.basename(path)[0..-4] }.
                 reject{ |name| %w[version u noirbrc].include?(name) }

    mods.each{ |mod|
      %w[enable disable].each{ |meth|
        Ripl.should.respond_to?("#{meth}_#{mod}") == true
      }
      %w[enabled? disabled?].each{ |meth|
        Ripl.should.respond_to?("#{mod}_#{meth}") == true
      }
    }
  end
end
