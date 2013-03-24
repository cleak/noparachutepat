import 'dart:html';
import 'dart:isolate';

import 'zz.dart';

import 'package:vector_math/vector_math.dart';

void initCanvas() {
  //print("Started");
  var body = query('body');
  var canvasContainer = query("#canvas-container");
  
  var width = document.body.scrollWidth;
  var height = document.body.scrollHeight;
  
  CanvasElement canvas = new CanvasElement(width:width, height:height);
  canvasContainer.append(canvas);
  
  CanvasRenderingContext2D c = canvas.getContext('2d');
  c.fillStyle = '#EEEEEE';
  c.fillRect(0, 0, width, height);
  
  //c.fillStyle = '#AAAAAA';
  //c.fillRect(10, 10, width - 20, height - 20);
  
  var p = new Pit();
  c.lineWidth = 2;
  //c.strokeStyle = '#888888';
  c.strokeStyle = '#555555';
  c.fillStyle = '#111111';
  c.translate(width / 2, 0);
  p.scale = new vec2(1, 10);
}

void main() {
  //initCanvas();
  
  var fs = new FourierSeries.linear(10, 20);
  print(fs.evaluate(1));
  
  World world = new World();
  world.start();
}
