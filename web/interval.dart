part of zz;

class Interval {
  /// The first x this interval is valid for.
  double startX;
  
  /// The last x this interval is valid for.
  double startArea;
  
  /// The last x this interval is valid for.
  double endX;
  
  /// The total volume in this interval.
  double totalIntervalArea;
  
  /// The line slope.
  double slope;
  
  /// The y-intercept.
  double b;
  
  /**
   * Constructs a new interval.
   */
  Interval(this.startX, this.endX, this.slope, this.b) {
    startArea = _areaAt(startX);
    totalIntervalArea = intervalArea(endX);
  }
  
  /**
   * Constructs a new interval from the given [start] and [end] points.
   */
  factory Interval.fromPoints(vec2 start, vec2 end) {
    var slope = (end.y - start.y) / (end.x - start.x);
    var b = start.y - slope * start.x;
    return new Interval(start.x, end.x, slope, b);
  }
  
  /**
   * Returns the total area under the curve (not just for the interval) up to
   * the given [x] value.
   */
  double _areaAt(double x) {
    return slope / 2.0 * x * x + b * x;
  }
  
  /**
   * Returns the area under the curve from the start of the interval to the
   * given [x] value.
   */
  double intervalArea(double x) {
    return _areaAt(x) - startArea;
  }

  /**
   * Gets the x value that would produce the given amount of area in intervalArea.
   */
  double xFromArea(double area) {
    if (slope == 0) {
      return area;
    }
    
    // Quadratic formula
    var c = -(startArea + area);
    var x = (-b + math.sqrt(b * b - 4.0 * slope / 2.0 * c)) / (slope);
    var computedArea = intervalArea(x);
    assert((1.0 - computedArea / area).abs() < 0.025);
    return x;
  }
}
