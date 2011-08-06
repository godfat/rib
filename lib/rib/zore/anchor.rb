
require 'rib'

module Rib::Anchor
  include Rib::Plugin
  Shell.use(self)

  def loop_eval str
    return super if Rib::Anchor.disabled?
    case obj_or_binding = (Rib.vars[:anchor] ||= []).last
      when NilClass
        super

      when Binding
        @binding = obj_or_binding
        super

      else
        obj_or_binding.instance_eval(str, "(#{config[:name]})", config[:line])
    end
  end

  def prompt
    return super if Rib::Anchor.disabled?
    if Rib.const_defined?(:Color) && kind_of?(Rib::Color) &&
       obj_or_binding = (Rib.vars[:anchor] ||= []).last

      super.sub(config[:name], format_color(obj_or_binding, config[:name]))
    else
      super
    end
  end

  # if the object is the same, then we're exiting from an anchor,
  # so don't print anything.
  def print_result result
    return super if Rib::Anchor.disabled?
    super unless !result.nil? &&
                 result.object_id == Rib.vars[:anchor_last].object_id
  end

  module Imp
    def short_inspect obj_or_binding
      obj_or_binding.inspect[0..9]
    end
  end

  module AnchorImp
    def anchor obj_or_binding
      return if Rib::Anchor.disabled?

      (Rib.vars[:anchor] ||= []) << obj_or_binding
      name = Rib::P.short_inspect(obj_or_binding)

      Rib.shells <<
        Rib::Shell.new(Rib.config.merge(
          :name   => name,
          :prompt => "#{name}(#{Rib.vars[:anchor].size})" +
                     (Rib.config[:prompt] || '>> ')))

      Rib.shell.loop
      Rib.vars[:anchor].last # the way to hide return value from Rib.anchor

    ensure
      return if Rib::Anchor.disabled?
      # stores to check if we're exiting from an anchor
      Rib.vars[:anchor_last] = Rib.vars[:anchor].pop
      Rib.shells.pop
    end
  end

  Plugin.extend(Imp)
  Rib   .extend(AnchorImp)
end
