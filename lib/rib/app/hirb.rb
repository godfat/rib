
require 'rib'

module Rib::Hirb
  include Rib::Plugin
  Shell.use(self)

  def format_result result
    return super if Hirb.disabled?
    ::Hirb::View.view_or_page_output(result) || super
  end
end

begin
  require 'hirb'
  ::Hirb.enable
rescue LoadError
  Rib.warn("Please install hirb to use hirb plugin.",
           "    gem install hirb")
  Rib::Hirb.disable
end
