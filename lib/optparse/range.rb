require 'optparse'

class OptionParser
  decimal = '\d+(?:_\d+)*'
  DecimalRange = /#{decimal}(?:\-#{decimal})/io

  float = "(?:#{decimal}(?:\\.(?:#{decimal})?)?|\\.#{decimal})(?:E[-+]?#{decimal})?"
  FloatRange = /#{float}-#{float}/io

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

  class StringRange; end

  [[DecimalRange, :to_i], [FloatRange, :to_f],
   [DateRange, DateRange.converter], [DateTimeRange, DateTimeRange.converter], [TimeRange, TimeRange.converter],
   [StringRange, :to_s]].each do |(accepter, converter)|
    accept accepter do |range,|
      return unless range
      terms = range.split('-')
      raise AmbiguousArgument if terms.length > 2
      terms << terms.first if terms.length == 1
      Range.new *terms.map(&converter)
    end
  end
end
