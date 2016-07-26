module Zazo
  module Tool

    class Classifier
      def initialize(parts)
        @string = parts.map(&:to_s).map(&:camelize).join('::')
      end

      def klass
        @string.constantize
      end
    end

  end
end
