part of zz;

class BoundingRect {
  /// The top left corner of the rectangle.
  vec2 origin;
  
  /// The width and height of the rectangle.
  vec2 dimensions;
  
  double get left => origin.x;
  double get right => origin.x + dimensions.x;
  
  double get top => origin.y;
  double get bottom => origin.y + dimensions.y;
  
  double get width => dimensions.x;
  double get height => dimensions.y;
  
  /// Gets all corner points for the rectangle.
  List<vec2> get points {
    List<vec2> allPoints = new List<vec2>(4);
    
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 2; j++) {
        allPoints[i + j * 2] = new vec2(i == 0 ? left : right, j == 0 ? top : bottom);
      }
    }
    
    return allPoints;
  }
  
  /**
   * Determines if the current rectangle and the given [pit] collide.
   */
  bool isCollision(Pit pit) {
    var wallPoints = pit.getInterval(top, bottom);
    
    // Check if any of the all points are in the rectangle.
    for (var i = 0; i < wallPoints.length; i++) {
      for (var j = 0; j < wallPoints[i].length; j++) {
        if (contains(wallPoints[i][j])) {
          return true;
        }
      }
    }
    
    // Check if any of the rectangle points are in the wall.
    var cornerPoints = points;
    for (var i  = 0; i < cornerPoints.length; i++) {
      if (pit.isCollision(cornerPoints[i])) {
        return true;
      }
    }
    
    return false;
  }
  
  /**
   * Determines if the rectangle contains the given [point].
   */
  bool contains(vec2 point) {
    // TODO: Handle rotations here
    var rectOffset = point - origin;
    
    if (rectOffset.x < 0 || rectOffset.y < 0) {
      return false;
    }
    
    if (rectOffset.x > dimensions.x || rectOffset.y > dimensions.y) {
      return false;
    }
    
    return true;
  }
  
  /**
   * Draws the rectangle.
   */
  void draw(CanvasRenderingContext2D c, String color) {
    // TODO: Take in the color as a param.
    c.save();
    c.fillStyle = color;
    c.fillRect(left, top, width, height);
    c.restore();
  }
}
