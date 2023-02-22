# frozen_string_literal: true

require 'rib'

module Rib; module LastValue
  extend Plugin
  Shell.use(self)

  attr_reader :last_value, :last_exception

  def print_result result
    return super if LastValue.disabled?
    @last_value = result
    super
  end

  def print_eval_error err
    return super if LastValue.disabled?
    @last_exception = err
    super
  end



  module Imp
    def last_value
      Rib.shell.last_value
    end

    def last_exception
      Rib.shell.last_exception
    end
  end

  Rib.extend(Imp)
end; end
