
require 'rib'

module Rib::Underscore
  include Rib::Plugin
  Shell.use(self)

  def loop_eval input
    return super if Underscore.disabled?
    value = super
    bound_object.send(:define_method, :_) do
      value
    end
    value
  end

  def print_eval_error e
    return super if Underscore.disabled?
    bound_object.send(:define_method, :__) do
      e
    end
    super
  end

  private
  def bound_object
    if respond_to?(:singleton_class)
      config[:binding].eval('self').singleton_class
    else
      class << config[:binding].eval('self'); self; end
    end
  end
end
