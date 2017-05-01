
module Rib; module Plugin
  attr_accessor :disabled

  def enable
    self.disabled = false
    if block_given? then yield else enabled? end
  ensure
    self.disabled = true if block_given?
  end

  def disable
    self.disabled = true
    if block_given? then yield else enabled? end
  ensure
    self.disabled = false if block_given?
  end

  def enabled?
    !disabled
  end

  def disabled?
    !!disabled
  end

  # Backward compatibility
  def const_missing mod
    if Rib.const_defined?(mod)
      Rib.warn("Using #{mod} is deprecated, please change to Rib::#{mod}",
               "This compatibility layer would be removed in Rib 1.6+",
               "Called: #{caller.first}")
      Rib.const_get(mod)
    else
      super
    end
  end

  def self.extended mod
    return unless mod.name

    snake_name = mod.name.sub(/(\w+::)+?(\w+)$/, '\2').
      gsub(/([A-Z][a-z]*)/, '\\1_').downcase[0..-2]

    code = (%w[enable disable].map{ |meth|
      <<-RUBY
        def #{meth}_#{snake_name} &block
          #{mod.name}.#{meth}(&block)
        end
      RUBY
    } + %w[enabled? disabled?].map{ |meth|
      <<-RUBY
        def #{snake_name}_#{meth} &block
          #{mod.name}.#{meth}(&block)
        end
      RUBY
    }).join("\n")

    Rib.singleton_class.module_eval(code, __FILE__, __LINE__)
  end
end; end
