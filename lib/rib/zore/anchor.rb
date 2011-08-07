
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
    return super unless config[:anchor]

    level = "(#{Rib.shells.size - 1})"
    if Rib.const_defined?(:Color) &&
       kind_of?(Rib::Color)       &&
       Rib::Color.enabled?

      "#{format_color(eval_binding, prompt_anchor)}#{level}#{super}"
    else
      "#{prompt_anchor}#{level}#{super}"
    end
  end

  private
  def prompt_anchor
    @prompt_anchor ||=
    if eval_binding.kind_of?(Binding)
      eval_binding.eval('self', __FILE__, __LINE__)
    else
      eval_binding
    end.inspect[0..9]
  end

  def bound_object
    return super if Rib::Anchor.disabled?
    return super if eval_binding.kind_of?(Binding)
    eval_binding
  end

  module AnchorImp
    def anchor obj_or_binding
      return if Rib::Anchor.disabled?

      if Rib.shell.running?
        Rib.shells << Rib::Shell.new(
          Rib.shell.config.merge( :binding => obj_or_binding,
                                  :anchor  => true          ))
      else
          Rib.shell.config.merge!(:binding => obj_or_binding,
                                  :anchor  => true          )
      end

      Rib.shell.loop

    # we can't use ensure block here because we need to do something
    # (i.e. throw :rib_skip) if there's no exception. this can't be
    # done via ensure because then we don't know if there's an
    # exception or not, and ensure block is always executed last
    rescue
      Rib.shells.pop
      raise
    else
      # only skip printing anchor result while there's another shell running
      Rib.shells.pop
      throw :rib_skip if Rib.shell.running?
    end
  end

  Rib.extend(AnchorImp)
end
