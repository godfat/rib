
module Rib; module Rack
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
    app, _ = ::Rack::Builder.parse_file(configru_path)
    self.app = app
    Rib.shell.eval_binding.eval('def app; Rib::Rack.app; end')
    Rib.say("Access your app via :app method")
  end

  def rack?
    File.exist?(configru_path)
  end

  def configru_path
    "#{Rib.config[:prefix]}/config.ru"
  end
end; end
