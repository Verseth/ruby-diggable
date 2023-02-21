# frozen_string_literal: true

require_relative 'diggable/version'

# Include in a class to give it the `#dig` method.
# It's implemented so that it calls public methods.
module Diggable
  # Extracts the nested value specified by the sequence of key objects by calling `dig` at each step,
  # returning `nil` if any intermediate step is `nil`.
  #
  # This implementation of `dig` uses `public_send` under the hood.
  #
  # @param args [Array<Symbol>, Array<String>]
  # @raise [TypeError] value has no #dig method
  # @return [Object]
  def dig(*args)
    return unless args.size.positive?

    return unless respond_to?(key = args.shift)

    value = public_send(key)
    return if value.nil?
    return value if args.empty?
    raise ::TypeError, "#{value.class} does not have #dig method" unless value.respond_to?(:dig)

    value.dig(*args)
  rescue ::ArgumentError
    nil
  end
end
