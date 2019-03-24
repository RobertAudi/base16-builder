module Base16
  module Builder
    class BaseCollection
      include Enumerable

      def initialize(items)
        raise NotImplementedError
      end

      def each(&block)
        block_given? or return items.to_enum
        items.each(&block)
      end

      def include?(item)
        case item
        when self.class
          items.include?(item)
        when String
          regex = Regexp.new(Regexp.escape(item), Regexp::IGNORECASE)
          items.any? { |i| i.name.match?(regex) }
        else
          false
        end
      end

      protected

      attr_reader :items
    end
  end
end
