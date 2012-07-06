
module Rib; end
module Rib::Plugin
  def self.included mod
    mod.send(:include, Rib)

    class << mod
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
    end

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

    meta_rib = if respond_to?(:singleton_class)
                 Rib.singleton_class
               else
                 class << Rib; self; end
               end

    meta_rib.module_eval(code, __FILE__, __LINE__)
  end
end
