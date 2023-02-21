# frozen_string_literal: true

require 'test_helper'

class DiggableTest < ::Minitest::Test
  class TestObject
    include ::Diggable

    # Sets instance variables and
    # defines methods based on given
    # keyword arguments
    def initialize(**kwargs)
      kwargs.each do |key, val|
        instance_variable_set(:"@#{key}", val)
        define_singleton_method(key) do
          instance_variable_get(:"@#{key}")
        end
      end
    end
  end

  attr_reader :obj

  def setup
    @obj = TestObject.new(
      object_method: {
        hash_key: [
          TestObject.new(eluwina: 3)
        ]
      },
      undiggable: ::Object.new
    )
  end

  should 'have a version number' do
    refute_nil ::Diggable::VERSION
  end

  should 'be able to dig using public methods' do
    assert_raises ::NoMethodError do
      obj.object_method[:hash_key][10].eluwina
    end
    assert_nil obj.dig(:object_method, :hash_key, 10, :eluwina)
  end

  should 'return nil when no such method' do
    assert_raises ::NoMethodError do
      obj.no_such_method
    end
    assert_nil obj.dig(:no_such_method, :something)
  end

  should 'raise an error when encountering an undiggable object' do
    assert_raises ::TypeError do
      obj.dig(:undiggable, :something)
    end
  end

  should 'call public methods on dig' do
    assert_equal 3, obj.object_method[:hash_key][0].eluwina
    assert_equal 3, obj.dig(:object_method, :hash_key, 0, :eluwina)
  end
end
