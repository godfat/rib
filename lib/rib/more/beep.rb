
require 'rib'

module Rib::Beep
  extend Rib::Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def before_loop
    super
    return self if Beep.disabled?
    beep if (Time.now - config[:started_at]) > beep_threshold
    Beep.disable
    self
  end

  private
  def beep
    print "\a"
  end

  def beep_threshold
    config[:beep_threshold] ||= 5
  end
end
