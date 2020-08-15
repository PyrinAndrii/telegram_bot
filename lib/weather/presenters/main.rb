module Weather
  module Presenters
    class Main
      # TODO: Вместо метода parse_data рекомендовал бы использовать гем dry-struct
      # https://dry-rb.org/gems/dry-struct/1.0/

      attr_accessor :temp, :feels_like, :temp_min, :temp_max

      def initialize(main)
        parse_data(main)
      end

      def parse_data(main)
        @temp       = main[:temp].to_f
        @temp_min   = main[:temp_min].to_f
        @temp_max   = main[:temp_max].to_f
        @feels_like = main[:feels_like].to_f
      end
    end
  end
end
