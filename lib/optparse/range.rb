require 'optparse'

class OptionParser
  # --port=8080-8082
  # --page=24-32,34-62 # not implemented for the first
  # ignore negative value for the first implementation
  decimal = '\d+(?:_\d+)*'
  DecimalRange = /#{decimal}(?:\-#{decimal})/io

  float = "(?:#{decimal}(?:\\.(?:#{decimal})?)?|\\.#{decimal})(?:E[-+]?#{decimal})?"
  FloatRange = /#{float}-#{float}/io

  [[DecimalRange, :to_i], [FloatRange, :to_f]].each do |(accepter, converter)|
    accept accepter do |range,|
      return unless range
      terms = range.split('-')
      raise AmbiguousArgument if terms.length > 2
      terms << terms.first if terms.length == 1
      Range.new *terms.map(&converter)
    end
  end
end
