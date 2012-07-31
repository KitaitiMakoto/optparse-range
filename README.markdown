OptionParser::Range
===================

[![Build Status](https://secure.travis-ci.org/KitaitiMakoto/optparse-range.png?branch=master)](http://travis-ci.org/KitaitiMakoto/optparse-range)

This RubyGem allows standard bundled [`OptionParser`][optparse] to accept option arguments as `Range` object.

Inspired by [Slop][slop] gem's [Range][sloprange] feature.

Note that `OptionParser::Range` module doesn't exist.

Installation
------------

Add this line to your application's Gemfile:

    gem 'optparse-range'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install optparse-range

Usage
-----

    require 'optparse/range'
    
    opts = OptionParser.new do |opti|
      opti.on '--page=STARTPAGE-ENDPAGE', OptionParser::DecimalIntegerRange
    end.getopts
    # for instance, when --page=024-160 passed
    opts #=> {"page"=>24..160}
    opts['page'].class #=> Range

When only one argument passed, it will be handled as both start and end:

    opts = OptionParser.new do |opti|
      opti.on '--port=STARTPORT-ENDPORT', OptionParser::DecimalIntegerRange
    end
    # when --port=8080
    opts #=> {"port"=>8080..8080}

You can replace `OptionParser::DecimalIntegerRange` in above example with other type of `Range`.
See below for types currently provided.

### Supported Types ###

#### `OptionParser::DecimalIntegerRange` ####

* decimal `Integer` range
* `--number=1-5` => `1..5`
*  only zero or positive integers are supported currently

#### `OptionParser::FloatRange` ####

* `Float` range
* `--ratio=1.2-1.5` => `1.2..1.5`
* only zero or positive floats are supported currently

#### `OptionParser::DateRange` ####
* `Date` range
* `--trip=0810-0820` => `#<Date: 2012-08-10 ((2456150j,0s,0n),+0s,2299161j)>..#<Date: 2012-08-20 ((2456160j,0s,0n),+0s,2299161j)>`
* format including hyphen is not supported currently
  * `--trip=2012-08-10-2012-08-20` => `OptionParser::AmbiguousArgument` raised

#### `OptionParser::DateTimeRange` ####

* `DateTime` range
* `--flight=0810T10:00-0810T12:20` => `#<DateTime: 2012-08-10T10:00:00+00:00 ((2456150j,36000s,0n),+0s,2299161j)>..#<DateTime: 2012-08-10T12:20:00+00:00 ((2456150j,44400s,0n),+0s,2299161j)>`
* format including hyphen is not supported currently
  * `--trip=2012-08-10T10:00:00-2012-08-20T19:30:00` => `OptionParser::AmbiguousArgument` raised

#### `OptionParser::TimeRange` ####

* `Time` range
* `--flight=10:00-12:20` => `>2012-07-29 10:00:00 +0900..2012-07-29 12:20:00 +0900`
* format including hyphen is not supported currently
  * `--trip=2012-08-10T10:00:00-2012-08-20T19:30:00` => `OptionParser::AmbiguousArgument` raised

#### `OptionParser::StringRange` ####

* `String` range
* `--password-chars=A-Z` => `"A".."Z"`

Adding Type of Rnage
--------------------

To add a type of range, use `OptionParser.accept_range`.

1. Define class which can be used as points of `Range`(`MyClass` here).
2. Define class or `Regexp` which allows `OptionParser` to accept class above
   as the points of `Range`(`MyClassRange`). Class is recommended.
3. Pass the class and block, `Symbol` or `Proc` which
   converts a point in command line option(`String`) to an object of point(`MyClass`).
   Block is used here. `to_proc` will be called when `Symbol` is passed.
4. Now, you can pass the class for range(`MyClassRange`) to `OptionParser#on`
   and use the option argument as `Range`.

Example:

    require 'optparse/range'
    
    class MyClass
      class << self
        def parse(arg)
          # parse arg and return MyClass object
          new(arg)
        end
      end
    
      attr_reader :arg
    
      def initialize(arg)
        @arg = arg
      end
    
      def <=>(other)
        @arg <=> other.arg
      end
    end
    
    class MyClassRange; end
    OptionParser.accept_range MyClassRange do |range|
      MyClass.parse range
    end
    
    opts = OptionParser.new do |opti|
      opti.on '--myoption=MYSTART-MYEND', MyClassRange
    end.getopts
    p opts

Result:

    $ ./mycommand --myoption=mystart-myend
    {"myoption"=>#<MyClass:0x000000031824c0 @arg="mystart">..#<MyClass:0x00000003182420 @arg="myend">}

Todos
-----

* More comments for YARD
* Negative numbers
* More classes
* `OptioniParser#accept_range`
* List of range(--page=1-3,6-7)
* API for `Range` excluding the end point(`1...5` in result)
* Range with single point, such like --age=-18(under 18) or --page=192-(all after page 192)
* Alternate delimiters
* Parsing `Date` such like "2012-07-23"(including "-")

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Links
-----

* [Homepage and source code][repo]
* [API Documentation][rubydoc]

[optparse]:  http://rubydoc.info/stdlib/optparse/frames
[slop]:      https://github.com/injekt/slop
[sloprange]: https://github.com/injekt/slop/wiki/Ranges
[repo]:      https://github.com/KitaitiMakoto/optparse-range
[rubydoc]:   http://rubydoc.info/gems/optparse-range/frames

License
-------

OptionParser::Range is released under the Ruby's license.
See the file LICENSE.txt.
