
module Rib; end
module Rib::Rails
  module_function
  def load
    require './config/boot'

    if File.exist?('./config/application.rb')
      Rib::Rails.load_rails3
    else
      Rib::Rails.load_rails2
    end

    puts("Loading #{::Rails.env} environment (Rails #{::Rails.version})")

  rescue LoadError => e
    abort("#{Rib.config[:name]}: Is this a Rails app?\n  #{e}")
  end

  def load_rails2
    ['./config/environment',
     'console_app'         ,
     'console_with_helpers'].each{ |f| require f }
  end

  def load_rails3
    ['./config/application',
     'rails/console/app'   ,
     'rails/console/helpers'].each{ |f| require f }

    ::Rails.application.require_environment!
  end
end

Rib.require_rc
Rib::Rails.load
