
module Rib; end
module Rib::Rack
  singleton_class.module_eval{ attr_accessor :app }

  module_function
  def load
    load_rack
  rescue LoadError => e
    Rib.abort("Error: #{e}", "Is this a Rack app?")
  end

  def load_rack
    require 'rack'
    Rib.abort("Error: Cannot find config.ru") unless rack?
    app, _ = Rack::Builder.parse_file('config.ru')
    self.app = app
    Rib.shell.config[:binding].eval('def app; Rib::Rack.app; end')
    Rib.say("Access your app via :app method")
  end

  def rack?
    File.exist?('config.ru')
  end
end
