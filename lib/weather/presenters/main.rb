module Weather
  module Presenters
    class Main
      attr_accessor :temp, :feels_like, :temp_min, :temp_max

      def initialize(main)
        parse_data(main)
      end

      def parse_data(main)
        @temp       = main[:temp]
        @temp_min   = main[:temp_min]
        @temp_max   = main[:temp_max]
        @feels_like = main[:feels_like]
      end
    end
  end
end
