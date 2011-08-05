
require 'rib'

module Rib::Rails
  include Rib::Plugin
  Shell.use(self)

  def before_loop
    load_rails
    super
  end

  module_function
  def load_rails
    require "#{Dir.pwd}/config/boot"

    if File.exist?("#{Dir.pwd}/config/application.rb")
      Rib::Rails.load_rails3
    else
      Rib::Rails.load_rails2
    end

    puts("Loading #{::Rails.env} environment (Rails #{::Rails.version})")

  rescue LoadError => e
    abort("#{name}: Is this a Rails app?\n  #{e}")
  end

  def load_rails2
    ["#{Dir.pwd}/config/environment",
     'console_app',
     'console_with_helpers'].each{ |f| require f }
  end

  def load_rails3
    ["#{Dir.pwd}/config/application",
     'rails/console/app',
     'rails/console/helpers'].each{ |f| require f }

    ::Rails.application.require_environment!
  end
end
