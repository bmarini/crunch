module Crunch
  class Row < Hash
    def methodize_keys!
      symbols, strings = keys.partition { |k| k.is_a?(Symbol) }

      symbols.each do |k|
        instance_eval %Q{
          def #{k}; self[:#{k}]; end
          def #{k}=(v); self[:#{k}] = v; end
        }, __FILE__, __LINE__ + 1
      end

      strings.each do |k|
        instance_eval %Q{
          def #{k}; self['#{k}']; end
          def #{k}=(v); self['#{k}'] = v; end
        }, __FILE__, __LINE__ + 1
      end

      self
    end
  end
end