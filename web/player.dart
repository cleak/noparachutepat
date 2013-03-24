part of zz;

class Player {
  BoundingRect boundingRect;
  vec2 velocity;
  vec2 position;
  
  static const PIXELS_PER_METER = 100.0;
  static const MAX_STEP = 0.1;
  static final GRAVITY = new vec2(0, 1.8);
 
  /**
   * Construct a new default [Player].
   */
  Player() {
    boundingRect = new BoundingRect();
    boundingRect.origin = new vec2(0, 0);
    boundingRect.dimensions = new vec2(80, 150);
    
    velocity = new vec2(0, 0);
    position = new vec2(0, 0);
  }
  
  /**
   * Updates the player with the given [timePassed].
   */
  void update(double timePassed) {
    timePassed = math.min(timePassed, MAX_STEP);
    
    position += velocity * timePassed * PIXELS_PER_METER; 
    // TODO: Update velocity better.
    velocity += GRAVITY * timePassed;
    
    boundingRect.origin = position;
  }
  
  /**
   * Draws the player on the given canvas context [c].
   */
  void draw(World world) {
    // For now, just draw the rect
    boundingRect.draw(world.context, "#1111dd");
  }
}
