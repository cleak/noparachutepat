library zz;

import 'dart:html';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

class Pit {
  /**
   * Contains a list of horizontal offsets for each slice of the pit. 
   */
  List<num> offsets;
  
  /**
   * Contains a list of horizontal widths for each slice of the pit.
   */
  List<num> widths;
  
  /**
   * Constructs a new pit with the given number of vertical [slices].
   */
  Pit(int slices) {
    var maxWidth = 400;
    var minWidth = 120;
    var maxWidthDelta = 50;
    var maxOffset = 250;
    var maxOffsetDelta = 20;
    
    this.offsets = new List(slices);
    this.widths = new List(slices);
    
    // TODO: Setup random initial condition
    offsets[0] = 0.0;
    widths[0] = 200.0;
    
    var rand = new Random();
    
    for (var i = 1; i < slices; i++) {
      // Generate offset
      offsets[i] = offsets[i - 1] + (rand.nextDouble() * 2 - 1) * maxOffsetDelta;
      offsets[i] = offsets[i].clamp(-maxOffset, maxOffset);
      
      // Generate width
      widths[i] = widths[i - 1] + (rand.nextDouble() * 2 - 1) * maxWidthDelta;
      widths[i] = widths[i].clamp(minWidth, maxWidth);
      
      print("<offset, width> <${offsets[i]}, ${widths[i]}>");
    }
  }
  
  /**
   * Gets the wall point at the given [sliceIndex] and scales it by [scale].
   * Returns the left side of the wall if [leftSide], otherwise returns the
   * right.
   */
  vec2 getWallPoint(int sliceIndex, bool leftSide, vec2 scale) {
    var side = leftSide ? -1 : 1;
    return new vec2(offsets[sliceIndex] + widths[sliceIndex] / 2 * side, sliceIndex) * scale;
  }
  
  /**
   * Draws the pit on the given 2d canvas [context] with [lineSpacing] pixels
   * between each line.
   */
  void draw(CanvasRenderingContext2D c, vec2 scale) {
    print("drawing");
    // Left side
    for (var side = 0; side < 2; side++) {
      c.beginPath();
      for (var i = 0; i < widths.length - 2; i++) {
        var p1 = getWallPoint(i, side == 0, scale);
        var p2 = getWallPoint(i + 1, side == 0, scale);
        var p3 = getWallPoint(i + 2, side == 0, scale);
        if (i == 0) {
          c.lineTo(p1.x, p1.y);
        }
        c.bezierCurveTo(p1.x, p1.y, p3.x, p3.y, p2.x, p2.y);
      }
      
      var lastPoint = getWallPoint(widths.length - 1, side == 0, scale);
      lastPoint.x = c.canvas.width / 2;
      
      if (side == 0) {
        lastPoint.x *= -1;
      }
      
      c.lineTo(lastPoint.x, lastPoint.y);
      c.lineTo(lastPoint.x, 0);
      c.stroke();
      c.fill();
    }
  }
}
