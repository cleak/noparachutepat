part of zz;

class Player {
  Avatar avatar;
  BoundingRect boundingRect;
  vec2 velocity;
  vec2 position;
  
  static const PIXELS_PER_METER = 100.0;
  static const MAX_STEP = 0.1;
  //static final GRAVITY = new vec2(0, 1.8);
  static final GRAVITY = new vec2(0, 2.5);
  static const SIDE_SPEED = 200.0;
  static final DRAG = 0.002;
  
  bool movingLeft = false;
  bool movingRight = false;
 
  /**
   * Construct a new default [Player].
   */
  Player() {
    position = new vec2(0, 0);
    velocity = new vec2(0, 0);
    
    boundingRect = new BoundingRect();
    boundingRect.origin = new vec2(0, 0);
    boundingRect.dimensions = new vec2(80, 150);
    
    avatar = new Avatar();
  }
  
  /**
   * Updates the player with the given [timePassed].
   */
  void update(double timePassed) {
    timePassed = math.min(timePassed, MAX_STEP);
    
    position += velocity * timePassed * PIXELS_PER_METER; 
    // TODO: Update velocity better.
    velocity += GRAVITY * timePassed;
    velocity -= velocity * DRAG;

    if (movingLeft) {
      position.x -= timePassed * SIDE_SPEED;
    }
      
    if (movingRight) {
      position.x += timePassed * SIDE_SPEED;
    }
    
    boundingRect.origin = position;
  }
  
  /**
   * Draws the player on the given canvas context [c].
   */
  void draw(World world) {
    // For now, just draw the rect
    boundingRect.draw(world.context, "#1111dd");
    avatar.draw(world);
  }
}
