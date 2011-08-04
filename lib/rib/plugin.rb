
module Rib; end
module Rib::Plugin
  def self.included mod
    mod.send(:include, Rib)

    class << mod
      attr_accessor :disabled

      def enable
        self.disabled = false
        yield if block_given?
      ensure
        disable if block_given?
      end

      def disable
        self.disabled = true
        yield if block_given?
      ensure
        enable if block_given?
      end

      def enabled?
        !disabled
      end

      def disabled?
        !!disabled
      end
    end

    snake_name = mod.name[/::\w+$/].tr(':', ''). # remove namespaces
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

    Rib.module_eval(code, __FILE__, __LINE__)
  end
end
