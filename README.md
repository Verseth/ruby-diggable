# Diggable

This Ruby gem which adds a module which when included to a class enables it to be used with the `dig` method.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add diggable

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install diggable

## Usage

Include it in a class to make it *diggable*.
The `Diggable` module implements the `dig` method
so that it calls public methods.

Here's a simple example.

```rb
class MyClass
  include Diggable

  attr_accessor :foo, :bar

  def initialize(foo:, bar:)
    @foo = foo
    @bar = bar
  end
end

obj = MyClass.new foo: [1, 2 ,3], bar: { some: { inner: :value } }
obj.dig(:foo, 0) #=> 1
obj.dig(:bar, :some, :inner) #=> :value

hash = { my_obj: MyClass.new(foo: 1, bar: ['hi mom', 'hi dad']) }
hash.dig(:my_obj, :foo) #=> 1
hash.dig(:my_obj, :bar, 1) #=> 'hi dad'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Verseth/ruby-diggable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
