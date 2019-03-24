require "yaml"

module Base16
  module Builder
    class Scheme
      attr_reader :name
      attr_reader :author
      attr_reader :bases

      def self.all
        scheme_files = Dir[File.join(Base16::Builder.schemes_dir, "*.yaml")]
        Base16::Builder::SchemesCollection.new(scheme_files)
      end

      def self.find(name)
        file_path = File.join(Base16::Builder.schemes_dir, "#{name}.yaml")

        unless File.file?(file_path)
          fail Error.new("Scheme not found: #{name}")
        end

        new(file: file_path)
      end

      def initialize(file:)
        yaml = YAML.load_file(file, fallback: {}) || {}

        @author = yaml.fetch("author")
        @name = yaml.fetch("scheme")

        bases = (0...16).map { |n| format("base%02X", n) }
        @bases = bases.each_with_object({}) do |base, obj|
          obj[base] = yaml.fetch(base)
        end
      end

      def slug(separator: "-")
        name.gsub(/[^a-z0-9\-_]+/i, separator).downcase
      end

      def to_s
        "#{name} by #{author}"
      end

      def inspect
        hex_bases = Hash[bases.map { |k, v| [k, "##{v}"] }]
        "#<#{self.class.name} name:#{name.inspect} author:#{author.inspect} bases:#{hex_bases.inspect}>"
      end

      def ==(other)
        case other
        when self.class
          name == other.name && author == other.author && bases == other.bases
        when String
          to_s == other || name == other
        else
          self == String(other)
        end
      end
    end
  end
end
