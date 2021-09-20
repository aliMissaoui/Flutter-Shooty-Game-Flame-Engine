import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flame/src/game/camera/viewport.dart' as vp;
import 'package:flutter/material.dart';
import 'package:shooty/game/player.dart';

class GameSpace extends FlameGame with PanDetector {
  late Player player;
  Offset? _pointerStartPosition;
  Offset? _pointerCurrentPosition;

  final double joystickRadius = 60;
  final double _deadZoneRadius = 10;
  @override
  Future<void> onLoad() async {
    await images.load('simpleSpace_tilesheet@2.png');

    print(size);

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('simpleSpace_tilesheet@2.png'),
      columns: 8,
      rows: 6,
    );

    player = Player(
      sprite: spriteSheet.getSpriteById(4),
      size: Vector2(64, 64),
      position: canvasSize / 2,
    );

    player.anchor = Anchor.center;
    // player.x = size[0] / 2;
    // player.y = size[0];
    add(player);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_pointerStartPosition != null) {
      canvas.drawCircle(
        _pointerStartPosition!,
        joystickRadius,
        Paint()..color = Colors.grey.withAlpha(100),
      );
    }

    if (_pointerCurrentPosition != null) {
      var delta = _pointerCurrentPosition! - _pointerStartPosition!;

      if (delta.distance > joystickRadius) {
        delta = _pointerStartPosition! +
            (Vector2(delta.dx, delta.dy).normalized() * joystickRadius)
                .toOffset();
      } else {
        delta = _pointerCurrentPosition!;
      }
      canvas.drawCircle(
        delta,
        20,
        Paint()..color = Colors.white.withAlpha(100),
      );
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.raw.globalPosition;
    _pointerCurrentPosition = info.raw.globalPosition;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _pointerCurrentPosition = info.raw.globalPosition;

    var delta = _pointerCurrentPosition! - _pointerStartPosition!;

    if (delta.distance > _deadZoneRadius) {
      player.setMoveDirection(Vector2(delta.dx, delta.dy));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;

    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    _pointerCurrentPosition = null;

    player.setMoveDirection(Vector2.zero());
  }
}
