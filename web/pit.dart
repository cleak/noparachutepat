part of zz;

/**
 * Represents the game's main pit area.
 */
class Pit {
  /**
   * Contains a list of horizontal offsets for each slice of the pit. 
   */
  List<List<double>> _offsets;
  
  /**
   * Contains a list of horizontal widths for each slice of the pit.
   */
  List<List<double>> _widths;
  
  vec2 scale;
  
  int _startIndex = 0;
  int _pageSize = 64;
  int _pageCount = 8;
  
  FourierSeries _widthGenerator;
  FourierSeries _offsetGenerator;
  
  /**
   * Constructs a new pit with the given number of vertical [slices].
   */
  Pit() {
    _widths = new List(_pageCount);
    _offsets = new List(_pageCount); 
    
    // TODO: Setup random initial condition
    _offsetGenerator = new FourierSeries.linear(100, 0.15);
    _widthGenerator = new FourierSeries.linear(100, 0.15);
    
    // Generate pages
    for (var i = 0; i < _pageCount; i++) {
      _widths[i] = generateWidths(i * _pageSize, 200.0);
      _offsets[i] = generateOffsets(i * _pageSize, 0.0);
    }
  }
  
  /**
   * Gets the wall point at the given [sliceIndex] and scales it by [scale].
   * Returns the left side of the wall if [leftSide], otherwise returns the
   * right.
   */
  vec2 getWallPoint(int sliceIndex, bool leftSide, vec2 scale) {
    // Shift pages if needed
    if (sliceIndex >= _pageSize * (_startIndex + _widths.length)) {
      _progressPages();
    }
    
    var side = leftSide ? -1 : 1;
    var pageIndex = sliceIndex ~/ _pageSize - _startIndex;
    var pageOffset = sliceIndex % _pageSize;
    
    return new vec2(_offsets[pageIndex][pageOffset]
      + _widths[pageIndex][pageOffset] / 2 * side, sliceIndex) * scale;
  }
  
  /**
   * Progresses the pages but removing the oldest page and generating a new
   * one.
   */
  void _progressPages() {
    _widths.removeAt(0);
    _offsets.removeAt(0);
    
    _widths.add(generateWidths(_pageSize * (_startIndex + _widths.length),
          _widths.last.last));
    _offsets.add(generateWidths(_pageSize * (_startIndex + _offsets.length),
        _offsets.last.last));
    
    _startIndex++;
  }
  
  /**
   * Generates a page of offset starting at the given sliceIndex with the given [startOffset].
   */
  List<double> generateOffsets(int sliceIndex, double startOffset) {
    var maxOffset = 300.0;
    var maxOffsetDelta = 25.0;
    
    var offsets = new List<double>(_pageSize);
    var lastOffset = startOffset;
    
    // Generate offsets
    for (int i = 0; i < offsets.length; i++) {
      lastOffset = lastOffset + (_offsetGenerator.evaluate(i / 7.0)) * maxOffsetDelta;
      lastOffset = lastOffset.clamp(-maxOffset, maxOffset);
      offsets[i] = lastOffset;
    }
    
    return offsets;
  }
  
  /**
   * Generates a page of widths starting at the given sliceIndex with the given [startWidth].
   */
  List<double> generateWidths(int sliceIndex, double startWidth) {
    var maxWidth = 400.0;
    var minWidth = 120.0;
    var maxWidthDelta = 50.0;
    
    var widths = new List<double>(_pageSize);
    var lastWidth = startWidth;
    
    // Generate widths
    for (int i = 0; i < widths.length; i++) {
      lastWidth = lastWidth + (_offsetGenerator.evaluate(i / 11.0)) * maxWidthDelta;
      lastWidth = lastWidth.clamp(minWidth, maxWidth);
      widths[i] = lastWidth;
    }
    
    return widths;
  }
  
  /**
   * Gets all points in the given interval specified by [top] and [bottom].
   * Includes the point just outside the interval on either end.  Returns two
   * arrays, representing the left and right walls respectively.
   */
  List<List<vec2>> getInterval(double top, double bottom) {
    var points = new List<List<vec2>>(2);
    
    var startIndex = (top / scale.y).floor().toInt();
    startIndex = math.max(0, startIndex);
    var endIndex = (bottom / scale.y).ceil().toInt() + 1;
    endIndex = math.max(0, endIndex);
    
    // Make sure there are at least 2 points
    if (endIndex - startIndex == 1) {
      endIndex++;
    }
    
    for (var side = 0; side < 2; side++) {
      points[side] = new List<vec2>(endIndex - startIndex);
      for (var i = startIndex; i < endIndex; i++) {
        points[side][i - startIndex] = getWallPoint(i, side == 0, scale);
      }
    }
    
    return points;
  }
  
  /**
   * Checks if the given [point] is colliding with either the left or right walls.
   */
  bool isCollision(vec2 point) {
    if (point.y < 0) {
      return false;
    }
    
    var wallPoints = getInterval(point.y, point.y);
    
    var stepFraction = (point.y - wallPoints[0][0].y) / (wallPoints[0][1].y - wallPoints[0][0].y);
    
    // Find wall boundry points.
    var boundries = new List<double>(2);
    for (var i = 0; i < 2; i++) {
      boundries[i] = wallPoints[i][0].x + (wallPoints[i][1].x - wallPoints[i][0].x) * stepFraction;  
    }
    
    // Check if the point is in the left wall.
    if (point.x < boundries[0]) {
      return true;
    }
    // Check if the point is in the right wall.    
    if (point.x > boundries[1]) {
      return true;
    }
    
    return false;
  }
  
  /**
   * Draws the pit on the given 2d canvas [context] with its current [scale].
   */
  void draw(CanvasRenderingContext2D c) {
    var firstIndex = _pageSize * _startIndex;
    var lastIndex = firstIndex + _pageSize * _widths.length;
    
    // Left side
    for (var side = 0; side < 2; side++) {
      // Filled
      c.beginPath();
      for (var i = firstIndex + 1; i < lastIndex - 2; i++) {
        var p = getWallPoint(i, side == 0, scale);
        
        var p0 = getWallPoint(i - 1, side == 0, scale);
        var p1 = getWallPoint(i + 1, side == 0, scale);
        
        var c0 = (p + p0) / 2;
        var c1 = (p + p1) / 2;
        if (i == 1) {
          c.moveTo(p0.x, p0.y);
        }
        c.bezierCurveTo(c0.x, c0.y, c1.x, c1.y, p1.x, p1.y);
      }
      
      var lastPoint = getWallPoint(lastIndex - 1, side == 0, scale);
      lastPoint.x = c.canvas.width / 2;
      
      if (side == 0) {
        lastPoint.x *= -1;
      }
      
      c.lineTo(lastPoint.x, lastPoint.y);
      c.lineTo(lastPoint.x, 0);
      c.fill();
      c.stroke();
    }
  }
  
  /**
   * Draws the the left and right side collision lines for the pit using the
   * given canvas context [c] at its current [scale].
   */
  void drawCollisionLines(CanvasRenderingContext2D c) {
    // Left side
    for (var side = 0; side < 2; side++) { 
      // Line
      c.beginPath();
      for (var i = 0; i < _widths.length; i++) {
        var p = getWallPoint(i, side == 0, scale);
        c.lineTo(p.x, p.y);
      }
    }
  }
}
