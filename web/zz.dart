library zz;

import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

part 'boundingrect.dart';
part 'fourierseries.dart';
part 'pit.dart';
part 'player.dart';
part 'scene.dart';
part 'world.dart';

typedef void Drawable(World world);
typedef void Updatable(double timePassed);
