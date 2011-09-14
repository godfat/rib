
module Rib; end
module Rib::Auto
  module_function
  def load
    app, name = %w[ramaze rails].find{ |name|
      require "rib/app/#{name}"
      app = Rib.const_get(name.capitalize)
      if app.send("#{name}?")
        break app, name
      end
    }

    if app
      Rib.say("Found #{name.capitalize}, loading it...")
      begin
        app.load
      rescue LoadError => e
        Rib.warn("Error: #{e}", "Is this a #{app} app?")
      end
    else
      Rib.warn("No app found")
    end
  end
end
