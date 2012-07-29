require 'test/unit'
require 'optparse/range'

class TestOptionParserRange < Test::Unit::TestCase
  def setup
    @opt = OptionParser.new
  end

  def test_decimal_integer_range
    assert_equal 81..123, parse_option(OptionParser::DecimalIntegerRange, '081-123')
    assert_equal 1..1, parse_option(OptionParser::DecimalIntegerRange, '1')
  end

  def test_float_range
    assert_equal (1.2)..(64.33), parse_option(OptionParser::FloatRange, '01.20-64.33')
    assert_equal (30.0)..(30.0), parse_option(OptionParser::FloatRange, '30')
  end

  def test_date_range
    actual = parse_option(OptionParser::DateRange, '0701-0731')
    assert_equal Date.parse('0701')..Date.parse('0731'), actual
  end

  def test_date_time_range
    actual = parse_option(OptionParser::DateTimeRange, '20120601T00:00:00-20120630T24:00:00')
    assert_equal DateTime.parse('20120601T00:00:00')..DateTime.parse('20120630T24:00:00'),
                 actual
  end

  def test_time_range
    actual = parse_option(OptionParser::TimeRange, '04:30-19:12:14')
    dawn = '4:30'
    dawn = Time.httpdate(dawn) rescue Time.parse(dawn)
    dusk = '19:12:14'
    dusk = Time.httpdate(dusk) rescue Time.parse(dusk)
    assert_equal dawn..dusk, actual
  end

  def test_string_range
    assert_equal 'A'..'Z', parse_option(OptionParser::StringRange, 'A-Z')
  end

  private

  def parse_option(accepter, arg)
    opts = {}
    @opt.def_option "--range=START-END", accepter do |range|
      opts['range'] = range
    end
    @opt.parse! ["--range=#{arg}"]
    opts['range']
  end
end
