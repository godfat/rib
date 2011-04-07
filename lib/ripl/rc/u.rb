
require 'ripl'

module Ripl::Rc; end
module Ripl::Rc::U
  def self.included mod
    mod.send(:include, Ripl::Rc)
    class << mod
      attr_accessor :disabled

      def enable
        self.disabled = false
      end

      def disable
        self.disabled = true
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
    code = %w[enable disable enabled? disabled?].map{ |meth|
      <<-RUBY
        def #{meth}_#{snake_name}
          #{mod.name}.#{meth}
        end
      RUBY
    }.join("\n")
    module_eval(code)
  end
end

Ripl.extend(Ripl::Rc::U)
