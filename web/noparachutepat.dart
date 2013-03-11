import 'dart:html';
import 'pit.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  initCanvas();
}

void initCanvas() {
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
  
  var p = new Pit(100);
  c.strokeStyle = '#888888';
  c.fillStyle = '#111111';
  c.translate(width / 2, 0);
  p.draw(c, new vec2(1, 10));
}

void reverseText(MouseEvent event) {
  var text = query("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  query("#sample_text_id").text = buffer.toString();
}
