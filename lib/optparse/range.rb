require 'optparse'

class OptionParser
  class << self
    def accept_range(accepter, converter)
      accept accepter do |range,|
        return range unless range
        points = range.split('-')
        raise AmbiguousArgument if points.length > 2
        points << points.first if points.length == 1
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

  class DateRange
    class << self
      attr_reader :converter
    end
    @converter = lambda {|date|
      begin
        Date.parse date
      rescue NameError
        require 'date'
        retry
      rescue ArgumentError
        raise InvalidArgument, date
      end
    }
  end
  accept_range DateRange, DateRange.converter

  class DateTimeRange
    class << self
      attr_reader :converter
    end
    @converter = lambda {|dt|
      begin
        DateTime.parse dt
      rescue NameError
        require 'date'
        retry
      rescue ArgumentError
        raise InvalidArgument, dt
      end
    }
  end
  accept_range DateTimeRange, DateTimeRange.converter

  class TimeRange
    class << self
      attr_reader :converter
    end
    @converter = lambda {|time|
      begin
        Time.httpdate(time) rescue Time.parse(time)
      rescue NoMethodError
        require 'time'
        retry
      rescue
        raise InvalidArgument, time
      end
    }
  end
  accept_range TimeRange, TimeRange.converter

  class StringRange; end
  accept_range StringRange, :to_s
end
