import 'package:lagorithms/src/models/floor_size.dart';

class GameSettings {
  FloorSize size;
  double tileSize;
  double tileMargin;
  double tileRadius;

  double dirtRate;

  int get rows => size.rows;
  int get cols => size.cols;

  GameSettings({
    required this.size,
    this.dirtRate = 0.1,
    this.tileSize = 30,
    this.tileMargin = 5,
    this.tileRadius = 10,
  });

  GameSettings copyWith({
    FloorSize? size,
    double? tileSize,
    double? tileMargin,
    double? tileRadius,
    double? dirtRate,
  }) {
    return GameSettings(
      size: size ?? this.size,
      tileSize: tileSize ?? this.tileSize,
      dirtRate: dirtRate ?? this.dirtRate,
      tileMargin: tileMargin ?? this.tileMargin,
      tileRadius: tileRadius ?? this.tileRadius,
    );
  }
}
