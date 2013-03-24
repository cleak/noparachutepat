part of zz;

/**
 * Represents a drawable scene.
 */
class Scene {
  /**
   * List of all drawable objects in this scene.
   */
  List<Drawable> _drawables;
  
  /**
   * Constructs a new scene.
   */
  Scene() {
    _drawables = new List<Drawable>();
  }
  
  /**
   * Adds the given [drawable] object to the scene.
   */
  void add(Drawable drawable) {
    _drawables.add(drawable);
  }
  
  /**
   * Removes the given [drawable] from the scene.
   */
  void remove(Drawable drawable) {
    _drawables.remove(drawable);
  }
  
  /**
   * Draws each object in the scene on the given canvas context [c].
   */
  void draw(World world) {
    for(var drawable in _drawables) {
      drawable(world);
    }
  }
}
