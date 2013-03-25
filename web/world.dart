part of zz;

/**
 * Represents the entire game world and all objects in it.
 */
class World {
  double best = 0.0;
  
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
  
  Pit pit;
  
  const START_Y = -600.0;
  
  /// List of keyboard keys and whether they're pressed or not.
  List<bool> keys;
  
  DivElement score;
  
  /**
   * Constructs a new empty game world.
   */
  World() {
    _rootScene = new Scene();
  }
  
  void start() {
    const double TARGET_FPS = 60.0;
    score = query("#score-text");
    
    updatables = new List<Updatable>();
    
    keys = new List<bool>(0x100);
    
    for (var i = 0; i < keys.length; i++) {
      keys[i] = false;
    }
    
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
    context.lineWidth = 2;
    context.strokeStyle = '#555555';
    context.fillStyle = '#111111';
    translation = new vec2(-width / 2, START_Y);
    
    _rootScene.add((c) => pit.draw(c));
    
    // Create a random rect
    var rect = new BoundingRect();
    
    player = new Player();
    
    reset();
    
    updatables.add(player.update);
    updatables.add((double timePassed) {
      if (player.boundingRect.isCollision(pit)) {
        reset();
      }
    });
    
    _rootScene.add(player.draw);
    
    window.onResize.listen((e) => resize());
    
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
      if (e.keyCode >= keys.length) { 
        return;
      }
      keys[e.keyCode] = true;
    });
    
    window.onKeyUp.listen((e) {
      if (e.keyCode >= keys.length) { 
        return;
      }
      keys[e.keyCode] = false;
    });
  }
  
  /**
   * Updates the input, propigating key presses as appropriate.
   */
  void updateInput() {
    player.movingLeft = (keys[KeyCode.LEFT] || keys[KeyCode.A]);
    
    player.movingRight =  (keys[KeyCode.RIGHT] || keys[KeyCode.S]);
  }
  
  /**
   * Formats the given distance as a score string and returns it.
   */
  String formatScore(double distnace) {
    return math.max(distnace / Player.PIXELS_PER_METER, 0).toStringAsFixed(1) + 'm';
  }
  
  /**
   * Resets the world.
   */
  void reset() {
    if (player.position.y > best) {
      best = player.position.y;
      var bestScoreDisplay = query('#best-score');
      bestScoreDisplay.text = formatScore(best);
    }
    
    player.position = new vec2(-40, 70 + START_Y);
    player.velocity = new vec2(0, 0);
    pit = new Pit();
    pit.scale = new vec2(1, 10);
  }
  
  /**
   * Handles resizes.
   */
  void resize() {
    canvas.width = document.body.scrollWidth;
    canvas.height = document.body.scrollHeight;
  }
  
  /**
   * Runs a single iteation of the world.
   */
  void _run(Timer timer) {
    // Run updates
    updateInput();
    var now = new DateTime.now();
    if (lastUpdate == null) {
      lastUpdate = now;
    }
    
    var timePassed = now.difference(lastUpdate).inMilliseconds / 1000.0;
    for (var updatable in updatables) {
      updatable(timePassed);
    }
    lastUpdate = now;
    
    score.innerHtml = formatScore(player.position.y);
    
    translation = player.position + new vec2(-canvas.width / 2, -100);
    
    // Prepare the canvas
    context.fillStyle = '#888888';
    context.setTransform(1, 0, 0, 1, 0, 0);
    context.translate(-translation.x, -translation.y);
    context.fillRect(translation.x, translation.y, canvas.width, canvas.height);
    context.fillStyle = '#eeeeee';
    if (translation.y < 0) {
      context.fillRect(translation.x, translation.y, canvas.width, math.min(-translation.y + 1, canvas.height));
    }
    
    // Draw
    draw();
  }
  
  /**
   * Draws all objects in the world.
   */
  void draw() => _rootScene.draw(this);
}
