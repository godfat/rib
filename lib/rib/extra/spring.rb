
module Spring
  module Commands
    class Rib
      def call
        load `which rib`.chomp
      end
    end

    Spring.register_command 'rib', Rib.new
  end
end
