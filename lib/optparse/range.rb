require 'optparse'

class OptionParser
  # --port=8080-8082
  # --page=24-32,34-62 # not implemented for the first
  # ignore negative value for the first implementation
  decimal = '\d+(?:_\d+)*'
  DecimalRange = /#{decimal}(?:\-#{decimal})/io

  float = "(?:#{decimal}(?:\\.(?:#{decimal})?)?|\\.#{decimal})(?:E[-+]?#{decimal})?"
  FloatRange = /#{float}-#{float}/io

  # --period=0701-0730
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

  [[DecimalRange, :to_i], [FloatRange, :to_f], [DateRange, DateRange.converter], [DateTimeRange, DateTimeRange.converter], [TimeRange, TimeRange.converter]].each do |(accepter, converter)|
    accept accepter do |range,|
      return unless range
      terms = range.split('-')
      raise AmbiguousArgument if terms.length > 2
      terms << terms.first if terms.length == 1
      Range.new *terms.map(&converter)
    end
  end
end
