part of zz;

/**
 * Random number generator that can be bias towards a specified number.
 */
class BiasRandom {
  double targetBias;
  double biasStrength;
  math.Random _rand;
  double _totalArea;
  
  List<Interval> intervals;
  
  /**
   * Constructs a new bias with the given target where [targetBias] is in the
   * range 0 - 1.
   */
  BiasRandom(this.targetBias, this.biasStrength, rand) {
    this._rand = rand;
    intervals = new List<Interval>();
    
    // Special cases for only one segment.
    if (targetBias > 0.0) {
      intervals.add(new Interval.fromPoints(new vec2(0, 1), new vec2(targetBias, biasStrength)));  
    }
    
    if (targetBias < 1.0) {
      intervals.add(new Interval.fromPoints(new vec2(targetBias, biasStrength), new vec2(1, 1)));  
    }
    
    _totalArea = 0.0;
    
    for (var interval in intervals) {
      _totalArea += interval.totalIntervalArea;
    }
  }
  
  /**
   * Retrieves the next random double in the range [0, 1].
   */
  double nextDouble() {
    var areaSoFar = 0.0;
    var inputRand = _rand.nextDouble() * _totalArea;
    for (var interval in intervals) {
      if (areaSoFar + interval.totalIntervalArea < inputRand) {
        areaSoFar += interval.totalIntervalArea;
        continue;
      }
      
      return interval.xFromArea(inputRand - areaSoFar);
    }
    
    assert(false);
  }
}

