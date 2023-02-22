# frozen_string_literal: true

require 'rib'

module Rib; module Hirb
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def format_result result
    return super if Hirb.disabled?
    ::Hirb::View.view_or_page_output(result) || super
  end
end

begin
  Rib.silence{
    require 'hirb'
    ::Hirb.enable
  }
rescue LoadError => e
  Rib.warn("Error: #{e}"                              ,
           "Please install hirb to use hirb plugin:\n",
           "    gem install hirb\n"                   ,
           "Or add hirb to Gemfile if that's the case")
  Rib::Hirb.disable
end; end
