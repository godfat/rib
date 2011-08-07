
require 'rib'

module Rib::Anchor
  include Rib::Plugin
  Shell.use(self)

  def loop_eval str
    return super if Rib::Anchor.disabled?
    if eval_binding.kind_of?(Binding)
      super
    else
      eval_binding.instance_eval(str, "(#{name})", line)
    end
  end

  def prompt
    return super if Rib::Anchor.disabled?
    if Rib.const_defined?(:Color) && kind_of?(Rib::Color)
      super.sub(name, format_color(eval_binding, name))
    else
      super
    end
  end

  private
  def bound_object
    return super if Rib::Anchor.disabled?
    super if eval_binding.kind_of?(Binding)
    eval_binding
  end

  module Imp
    def short_inspect obj_or_binding
      obj_or_binding.inspect[0..9]
    end
  end

  module AnchorImp
    def anchor obj_or_binding
      return if Rib::Anchor.disabled?

      # TODO: this is not really a good idea, how do we know we really
      #       need to do cleanup? what if the newly created shell didn't
      #       really be created?
      @level ||= 0
      @level  += 1

      name = Rib::P.short_inspect(obj_or_binding)

      Rib.shells <<
        Rib::Shell.new(Rib.config.merge(
          :name   => name, :binding => obj_or_binding,
          :prompt => "#{name}(#{@level})#{Rib.config[:prompt] || '>> '}"))

      Rib.shell.loop

    # we can't use ensure block here because we need to do something
    # (i.e. throw :rib_skip) if there's no exception. this can't be
    # done via ensure because then we don't know if there's an
    # exception or not, and ensure block is always executed last
    rescue
      @level -= 1
      Rib.shells.pop
      raise
    else
      # only skip printing anchor result while there's another shell running
      @level -= 1
      Rib.shells.pop
      throw :rib_skip if Rib.shell.running?
    end
  end

  Plugin.extend(Imp)
  Rib   .extend(AnchorImp)
end
