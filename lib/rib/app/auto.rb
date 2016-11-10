
module Rib; end
module Rib::Auto
  module_function
  def load
    app, name = %w[ramaze rails rack].find{ |n|
      require "rib/app/#{n}"
      a = Rib.const_get(n.capitalize)
      break a, n if a.public_send("#{n}?")
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
