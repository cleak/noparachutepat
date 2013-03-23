part of zz;

/**
 * Represents the entire game world and all objects in it.
 */
class World {
  /// The root scene of the world.
  Scene _rootScene;
  
  /// The current translation for the world.
  vec2 translation = new vec2(0, 0);
  
  /// The current rotation for the world.
  double rotation = 0.0;
  
  /// The main canvas.
  CanvasElement _canvas;
  
  /// The rendering context for the main canvas.
  CanvasRenderingContext2D _context;
  
  Timer _runTimer;
  
  /**
   * Constructs a new empty game world.
   */
  World() {
    _rootScene = new Scene();
  }
  
  void start() {
    const double TARGET_FPS = 60.0;
    
    // TODO: Make this a param somewhere.
    var canvasContainer = query("#canvas-container");
    
    var width = document.body.scrollWidth;
    var height = document.body.scrollHeight;
    
    _canvas = new CanvasElement(width:width, height:height);
    canvasContainer.append(_canvas);
    
    _context = _canvas.getContext('2d');
    _context.fillStyle = '#EEEEEE';
    _context.fillRect(0, 0, width, height);
    
    // Create and draw the pit
    var p = new Pit();
    _context.lineWidth = 2;
    _context.strokeStyle = '#555555';
    _context.fillStyle = '#111111';
    translation = new vec2(-width / 2, 0);
    
    p.scale = new vec2(1, 10);
    _rootScene.add((c) => p.draw(c));
    
    // Create a random rect
    var rect = new BoundingRect();
    rect.origin = new vec2(0, 50);
    rect.dimensions = new vec2(100, 150);
    _rootScene.add((c) {
      if (rect.isCollision(p)) {
        rect.draw(c, '#ff0000');
      } else {
        rect.draw(c, '#0000ff');
      }
    });
    
    _runTimer = new Timer.periodic(new Duration(milliseconds:(1000.0 / TARGET_FPS).toInt()), _run);
    _canvas.onKeyDown.listen((e) {
      _context.translate(0, -1);
      print("$e");
    });
    
    window.onKeyDown.listen((e) {
      switch (e.keyCode) {
        case KeyCode.UP:
        case KeyCode.W:
          translation.y -= 2;
          rect.origin.y -= 2;
          break;

        case KeyCode.DOWN:
        case KeyCode.R:
          translation.y += 2;
          rect.origin.y += 2;
          break;

        case KeyCode.LEFT:
        case KeyCode.A:
          translation.x -= 2;
          rect.origin.x -= 2;
          break;

        case KeyCode.RIGHT:
        case KeyCode.S:
          translation.x += 2;
          rect.origin.x += 2;
          break;
      }
    });
    _canvas.onKeyDown.listen((e) => print("Hello!"));
    _canvas.onKeyPress.listen((e) => print("Key press!"));
    _canvas.onKeyUp.listen((e) => print("Key up!"));
  }
  
  /**
   * Runs a single iteation of the world.
   */
  void _run(Timer timer) {
    // TODO: Do a better job clearing the canvas here
    _context.fillStyle = '#888888';
    _context.setTransform(1, 0, 0, 1, 0, 0);
    _context.translate(-translation.x, -translation.y);
    _context.fillRect(translation.x, translation.y, _canvas.width, _canvas.height);
    _context.fillStyle = '#eeeeee';
    draw();
  }
  
  /**
   * Draws all objects in the world.
   */
  void draw() => _rootScene.draw(_context);
}
