
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
    @names.each do |name|
      %w[enable disable].each do |meth|
        expect(Rib).respond_to?("#{meth}_#{name}")
      end

      %w[enabled? disabled?].each do |meth|
        expect(Rib).respond_to?("#{name}_#{meth}")
      end
    end
  end

  would 'be the same as mod methods' do
    @mods.shuffle.take(@mods.size/2).each(&:disable)

    @names.each do |name|
      %w[enabled? disabled?].each do |meth|
        expect(Rib.send("#{name}_#{meth}")).eq \
          @mods.find{ |mod|
            mod.name[/::\w+$/].tr(':', '') ==
            name.gsub(/([^_]+)/){$1.capitalize}.tr('_', '') }.
          send(meth)
      end
    end
  end
end
