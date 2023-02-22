# frozen_string_literal: true

require 'rib'

module Rib; module Anchor
  extend Plugin
  Shell.use(self)

  # --------------- Rib API ---------------

  def prompt
    return super if Rib::Anchor.disabled?
    return super unless anchor?

    level = "(#{Rib.shells.size - 1})"
    if Rib.const_defined?(:Color) &&
       kind_of?(Rib::Color)       &&
       Rib::Color.enabled?

      "#{format_color(eval_binding, prompt_anchor)}#{level}#{super}"
    else
      "#{prompt_anchor}#{level}#{super}"
    end
  end

  def anchor?
    !!config[:prompt_anchor]
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

  module Imp
    # Enter an interactive Rib shell based on a particular context.
    #
    # @api public
    # @param obj_or_binding [Object, Binding] The context of the shell.
    # @param opts [Hash] The config hash passed to the newly created shell.
    #   See {Rib::Shell#initialize} for all possible options.
    # @return [Rib::Skip] This is the mark telling Rib do not print anything.
    #   It's only used internally in Rib.
    # @see Rib::Shell#initialize
    # @example
    #   Rib.anchor binding
    #   Rib.anchor 123
    def anchor obj_or_binding, opts={}
      return if Rib::Anchor.disabled?

      if Rib.shell.running?
        Rib.shells << Rib::Shell.new(
          Rib.shell.config.merge( :binding       => obj_or_binding,
                                  :prompt_anchor => true         ).
                           merge(opts))
      else
          Rib.shell.config.merge!(:binding       => obj_or_binding,
                                  :prompt_anchor => true         ).
                           merge!(opts)
      end

      Rib.shell.loop
      Rib::Skip

    ensure
      Rib.shells.pop
    end

    def stop_anchors
      Rib.shells.select(&:anchor?).each(&:stop)
      Rib::Skip
    end
  end

  Rib.extend(Imp)
end; end
