import 'package:flame/components.dart';

class Player extends SpriteComponent {
  Vector2 _moveDirection = Vector2.zero();
  double _speed = 300;
  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(
          sprite: sprite,
          position: position,
          size: size,
        );

  @override
  void update(double dt) {
    super.update(dt);

    this.position += _moveDirection.normalized() * _speed * dt;
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
