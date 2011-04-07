
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
  end
end
