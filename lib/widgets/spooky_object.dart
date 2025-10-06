enum SpookyObjectType {
  goldenPumpkin,
  trap,
  decoy,
  moving,
}

class SpookyObject {
  final String id;
  final SpookyObjectType type;
  final double x;
  final double y;
  final double size;
  final double? velocityX;
  final double? velocityY;

  SpookyObject({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.size,
    this.velocityX,
    this.velocityY,
  });

  SpookyObject copyWith({
    String? id,
    SpookyObjectType? type,
    double? x,
    double? y,
    double? size,
    double? velocityX,
    double? velocityY,
  }) {
    return SpookyObject(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
      velocityX: velocityX ?? this.velocityX,
      velocityY: velocityY ?? this.velocityY,
    );
  }
}
