require 'optparse'

class OptionParser
  class << self
    def accept_range(accepter, converter=nil, &block)
      accept accepter do |range,|
        return range unless range
        points = range.split('-')
        raise AmbiguousArgument if points.length > 2
        points << points.first if points.length == 1
        converter = block if block
        Range.new *points.map(&converter)
      end
    end
  end

  decimal = '\d+(?:_\d+)*'
  DecimalIntegerRange = /#{decimal}(?:\-#{decimal})/io
  accept_range DecimalIntegerRange, :to_i

  float = "(?:#{decimal}(?:\\.(?:#{decimal})?)?|\\.#{decimal})(?:E[-+]?#{decimal})?"
  FloatRange = /#{float}-#{float}/io
  accept_range FloatRange, :to_f

  class StringRange; end
  accept_range StringRange, :to_s

  class DateRange; end
  accept_range DateRange do |date|
    begin
      Date.parse date
    rescue NameError
      retry if require 'date'
      raise
    rescue ArgumentError
      raise InvalidArgument, date
    end
  end

  class DateTimeRange; end
  accept_range DateTimeRange do |dt|
    begin
      DateTime.parse dt
    rescue NameError
      retry if require 'date'
      raise
    rescue ArgumentError
      raise InvalidArgument, dt
    end
  end

  class TimeRange; end
  accept_range TimeRange do |time|
    begin
      Time.httpdate(time) rescue Time.parse(time)
    rescue NoMethodError
      retry if require 'time'
      raise
    rescue
      raise InvalidArgument, time
    end
  end
end
