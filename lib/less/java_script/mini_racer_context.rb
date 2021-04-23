begin
  require 'mini_racer' unless defined?(MiniRacer)
rescue LoadError => e
  warn "[WARNING] Please install gem 'min_racer' to use Less."
  raise e
end

module Less
  module JavaScript
    class MiniRacerContext
      def self.instance
        new
      end

      def initialize
        @mini_racer = MiniRacer::Context.new
      end

      def unwrap
        @mini_racer
      end

      def exec(&block)
        @min_racer.exec(&block)
      end

      def eval(source, options = nil) # passing options not supported
        source = source.encode('UTF-8') if source.respond_to?(:encode)
        @min_racer.eval("(#{source})")
      end

      def call(properties, *args)
        args.last.is_a?(::Hash) ? args.pop : nil # extract_options!

        lock do
          @min_racer.eval(properties).call(*args)
        end
      end

      def method_missing(symbol, *args)
        if @min_racer.respond_to?(symbol)
          @min_racer.send(symbol, *args)
        else
          super
        end
      end
    end
  end
end
