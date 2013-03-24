part of zz;

/**
 * Represents the entire game world and all objects in it.
 */
class World {
  /// The root scene of the world.
  Scene _rootScene;
  
  /// The current translation for the world.
  vec2 translation = new vec2(0, 0);
  
  List<Updatable> updatables;
  
  /// The current rotation for the world.
  double rotation = 0.0;
  
  DateTime lastUpdate;
  
  /// The main canvas.
  CanvasElement canvas;
  
  /// The rendering context for the main canvas.
  CanvasRenderingContext2D context;
  
  Timer _runTimer;
  
  Player player;
  
  const START_Y = -600.0;
  
  /**
   * Constructs a new empty game world.
   */
  World() {
    _rootScene = new Scene();
  }
  
  void start() {
    const double TARGET_FPS = 60.0;
    
    updatables = new List<Updatable>();
    
    // TODO: Make this a param somewhere.
    var canvasContainer = query("#canvas-container");
    
    var width = document.body.scrollWidth;
    var height = document.body.scrollHeight;
    
    canvas = new CanvasElement(width:width, height:height);
    canvasContainer.append(canvas);
    
    context = canvas.getContext('2d');
    context.fillStyle = '#EEEEEE';
    context.fillRect(0, 0, width, height);
    
    // Create and draw the pit
    var p = new Pit();
    context.lineWidth = 2;
    context.strokeStyle = '#555555';
    context.fillStyle = '#111111';
    translation = new vec2(-width / 2, START_Y);
    
    p.scale = new vec2(1, 10);
    _rootScene.add((c) => p.draw(c));
    
    // Create a random rect
    var rect = new BoundingRect();
    
    player = new Player();
    player.position = new vec2(-40, 70 + START_Y);
    
    updatables.add(player.update);
    _rootScene.add(player.draw);
    
    /*_rootScene.add((c) {
      if (rect.isCollision(p)) {
        rect.draw(c, '#ff0000');
      } else {
        rect.draw(c, '#0000ff');
      }
    });*/
    
    _runTimer = new Timer.periodic(new Duration(milliseconds:(1000.0 / TARGET_FPS).toInt()), _run);
    canvas.onKeyDown.listen((e) {
      context.translate(0, -1);
      print("$e");
    });
    
    window.onKeyDown.listen((e) {
      switch (e.keyCode) {
        case KeyCode.UP:
        case KeyCode.W:
          player.position.y -= 2;
          break;

        case KeyCode.DOWN:
        case KeyCode.R:
          player.position.y += 2;
          break;

        case KeyCode.LEFT:
        case KeyCode.A:
          player.position.x -= 2;
          break;

        case KeyCode.RIGHT:
        case KeyCode.S:
          player.position.x += 2;
          break;
      }
    });
    canvas.onKeyDown.listen((e) => print("Hello!"));
    canvas.onKeyPress.listen((e) => print("Key press!"));
    canvas.onKeyUp.listen((e) => print("Key up!"));
  }
  
  /**
   * Resets the world.
   */
  void reset() {
    player.position = new vec2(-40, 70 + START_Y);
  }
  
  /**
   * Runs a single iteation of the world.
   */
  void _run(Timer timer) {
    // Run updates
    var now = new DateTime.now();
    if (lastUpdate == null) {
      lastUpdate = now;
    }
    
    var timePassed = now.difference(lastUpdate).inMilliseconds / 1000.0;
    for (var updatable in updatables) {
      updatable(timePassed);
    }
    lastUpdate = now;
    
    translation = player.position + new vec2(-canvas.width / 2, -100);
    
    // Prepare the canvas
    context.fillStyle = '#888888';
    context.setTransform(1, 0, 0, 1, 0, 0);
    context.translate(-translation.x, -translation.y);
    context.fillRect(translation.x, translation.y, canvas.width, canvas.height);
    context.fillStyle = '#eeeeee';
    if (translation.y < 0) {
      context.fillRect(translation.x, translation.y, canvas.width, math.min(-translation.y, canvas.height));
    }
    
    // Draw
    draw();
  }
  
  /**
   * Draws all objects in the world.
   */
  void draw() => _rootScene.draw(this);
}
