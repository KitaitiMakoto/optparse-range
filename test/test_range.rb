$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'test/unit'
require 'optparse/range'

class TestOptionParserRange < Test::Unit::TestCase
  def setup
    @opt = OptionParser.new
  end

  def test_decimal_range
    pages = nil
    @opt.def_option '--page=STARTPAGE-ENDPAGE', OptionParser::DecimalRange do |range|
      pages = range
    end

    assert_equal(%w'', no_error {@opt.parse! %w'--page=081-123'})
    assert_equal(81..123, pages)
    assert_equal(%w'', no_error {@opt.parse! %w'--page=1'})
    assert_equal(1..1, pages)
  end

  def test_float_range
    arc = nil
    @opt.def_option '--arc=STARDEGREE-ENDDEGREE', OptionParser::FloatRange do |range|
      arc = range
    end

    assert_equal(%w'', no_error {@opt.parse! %w'--arc=01.20-64.33'})
    assert_equal(1.2..64.33, arc)
    assert_equal(%w'', no_error {@opt.parse! %w'--arc=30'})
    assert_equal(30.0..30.0, arc)
  end

  private

  # from Ruby's test_optparse.rb
  class DummyOutput < String
    alias write <<
  end

  # from Ruby's test_optparse.rb
  def no_error(*args)
    $stderr, stderr = DummyOutput.new, $stderr
    assert_nothing_raised(*args) {return yield}
  ensure
    stderr, $stderr = $stderr, stderr
    $!.backtrace.delete_if {|e| /\A#{Regexp.quote(__FILE__)}:#{__LINE__-2}/o =~ e} if $!
    assert_empty(stderr)
  end
end
