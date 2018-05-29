
require 'rib'

module Rib; module Beep
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def loop_once
    return super if Beep.disabled?
    beep if started_at && (Time.now - started_at) > beep_threshold
    config[:started_at] = Time.now
    super
  end

  private
  def beep
    print "\a"
  end

  def beep_threshold
    config[:beep_threshold] ||= 5
  end
end; end
