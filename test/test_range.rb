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

  def test_date_range
    period = nil
    @opt.def_option '--period=STARTDATE-ENDDATE', OptionParser::DateRange do |range|
      period = range
    end

    assert_equal(%w'', no_error {@opt.parse! %w'--period=0701-0731'})
    assert_equal(Date.parse('0701')..Date.parse('0731'), period)
  end

  def test_date_time_range
    period = nil
    @opt.def_option '--period=STARTDATETIME-ENDDATETIME', OptionParser::DateTimeRange do |range|
      period = range
    end

    assert_equal(%w'', no_error {@opt.parse! %w'--period=20120601T00:00:00-20120630T24:00:00'})
    assert_equal(DateTime.parse('20120601T00:00:00')..DateTime.parse('20120630T24:00:00'), period)
  end

  def test_time_range
    daytime = nil
    @opt.def_option '--daytime=DAWNTIME-DUSKTIME', OptionParser::TimeRange do |range|
      daytime = range
    end

    assert_equal(%w"", no_error {@opt.parse! %w'--daytime=04:30-19:12:14'})
    require 'time'
    dawn = '4:30'
    dawn = Time.httpdate(dawn) rescue Time.parse(dawn)
    dusk = '19:12:14'
    dusk = Time.httpdate(dusk) rescue Time.parse(dusk)
    assert_equal(dawn..dusk, daytime)
  end

  def test_string_range
    chars = nil
    @opt.def_option '--char=STARTCHAR-ENDCHAR', OptionParser::StringRange do |range|
      chars = range
    end

    assert_equal(%w'', no_error {@opt.parse! %w'--char=A-Z'})
    assert_equal('A'..'Z', chars)
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
