
require 'rib'

module Rib::Underscore
  extend Rib::Plugin
  Shell.use(self)

  IVAR = {:_  => :@__rib_result__,
          :__ => :@__rib_exception__}

  # --------------- Rib API ---------------

  def before_loop
    return super if Underscore.disabled?
    eliminate_warnings
    inject_inspecter
    super
  end

  def print_result result
    return super if Underscore.disabled?
    bound_object.instance_variable_set(:@__rib_result__, result)
    super
  end

  def print_eval_error err
    return super if Underscore.disabled?
    bound_object.instance_variable_set(:@__rib_exception__, err)
    super
  end



  private
  def eliminate_warnings
    IVAR.values.each{ |ivar| bound_object.instance_variable_set(ivar, nil) }
  end

  def inject_inspecter
    IVAR.each{ |k, v|
      bound_singleton.send(:define_method, k){
        instance_variable_get(v)
      } unless bound_object.respond_to?(k) # only inject for innocences
    }
  rescue TypeError
    # can't define singleton method for immediate value
  end

  def bound_singleton
    if respond_to?(:singleton_class)
      bound_object.singleton_class
    else
      class << bound_object; self; end
    end
  end
end
