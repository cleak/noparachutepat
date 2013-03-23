part of zz;

/**
 * Represents a fourier series.
 */
class FourierSeries {
  /// The a coefficients.
  List<double> _a;
  /// The a coefficients.
  List<double> _b;
  
  /**
   * Constructs a new fourier series the given amount of [terms].
   */
  FourierSeries(int terms) {
    _a = new List<double>(terms);
    _b = new List<double>(terms);
    
    for (var i = 0; i < terms; i++) {
      _a[i] = 0.0;
      _b[i] = 0.0;
    }
  }
  
  /**
   * Constructs a fourier series where the terms decrease linearly.
   */
  FourierSeries.linear(int terms, num maxTerm) {
    _a = new List<double>(terms);
    _b = new List<double>(terms);
    
    var rand = new math.Random();
    for (var i = 0; i < terms; i++) {
      _a[i] = ((rand.nextDouble() * 2 - 1) * (terms - i)) / terms * maxTerm;
      _b[i] = ((rand.nextDouble() * 2 - 1) * (terms - i)) / terms * maxTerm;
    }
    
    _a[0] = 0.0;
  }
    
  /**
   * Evaluates the series [at] the given value.
   */
  double evaluate(num at) {
    var total = _a[0] / 2;
    for (var n = 1; n < _a.length; n++) {
      total += _a[n] * math.cos(n * at) + _b[n] * math.sin(n * at);
    }
    return total;
  }
}