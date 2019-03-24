module Base16
  module Builder
    class TemplatesCollection < BaseCollection
      def initialize(items)
        @items = items.map do |item|
          Base16::Builder::Template.new(file: item)
        end
      end

      def render(schemes:)
        items.each do |item|
          item.render(schemes: schemes)
        end
      end
    end
  end
end
