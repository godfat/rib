
require 'ripl/rc/u'

module Ripl::Rc::Anchor
  include Ripl::Rc::U

  def loop_eval(str)
    case obj_or_binding = (config[:rc_anchor] ||= []).last
      when NilClass
        super

      when Binding
        @binding = obj_or_binding
        super

      else
        obj_or_binding.instance_eval(str, "(#{@name})", @line)
    end
  end

  def prompt
    if Ripl::Rc.const_defined?(:Color) && kind_of?(Ripl::Rc::Color) &&
       obj_or_binding = (config[:rc_anchor] ||= []).last

      super.sub(@name, format_result_with_display(obj_or_binding, @name))
    else
      super
    end
  end

  # if the object is the same, then we're exiting from an anchor,
  # so don't print anything.
  def print_result result
    super unless !result.nil? &&
                 result.object_id == Ripl.config[:rc_anchor_last].object_id
  end

  module Imp
    def short_inspect obj_or_binding
      obj_or_binding.inspect[0..9]
    end
  end

  module AnchorImp
    def anchor obj_or_binding
      return if Ripl::Rc::Anchor.disabled?
      if Ripl.config[:rc_init].nil?
        Ripl::Runner.load_rc(Ripl.config[:riplrc])
        Ripl.config[:rc_init] = true
      end

      (Ripl.config[:rc_anchor] ||= []) << obj_or_binding
      name = Ripl::Rc::U.short_inspect(obj_or_binding)
      Ripl::Shell.create(Ripl.config.merge(
        :name   => name,
        :prompt => "#{name}(#{Ripl.config[:rc_anchor].size})" +
                   Ripl.config[:prompt])).loop

      # stores to check if we're exiting from an anchor
      Ripl.config[:rc_anchor_last] = Ripl.config[:rc_anchor].pop
    end
  end
end

module Ripl::Rc::U; extend Ripl::Rc::Anchor::Imp; end

Ripl::Shell.include(Ripl::Rc::Anchor)
Ripl.config[:prompt] ||= Ripl::Shell::OPTIONS[:prompt]
# define Ripl.anchor
Ripl    .extend(Ripl::Rc::Anchor::AnchorImp)
Ripl::Rc.extend(Ripl::Rc::Anchor::AnchorImp)
