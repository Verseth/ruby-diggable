# frozen_string_literal: true

require_relative 'diggable/version'

# Include in a class to give it the `#dig` method.
# It's implemented so that it calls public methods.
#
# Example:
#
#       class MyClass
#         include Diggable
#
#         attr_accessor :foo, :bar
#
#         def initialize(foo:, bar:)
#           @foo = foo
#           @bar = bar
#         end
#       end
#
#       obj = MyClass.new foo: [1, 2 ,3], bar: { some: { inner: :value } }
#       obj.dig(:foo, 0) #=> 1
#       obj.dig(:bar, :some, :inner) #=> :value
#
#       hash = { my_obj: MyClass.new(foo: 1, bar: ['hi mom', 'hi dad']) }
#       hash.dig(:my_obj, :foo) #=> 1
#       hash.dig(:my_obj, :bar, 1) #=> 'hi dad'
#
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
