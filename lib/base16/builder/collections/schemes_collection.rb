module Base16
  module Builder
    class SchemesCollection < BaseCollection
      def initialize(items)
        @items = items.map do |item|
          Base16::Builder::Scheme.new(file: item)
        end
      end
    end
  end
end
