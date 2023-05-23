import 'package:lagorithms/src/providers/game_provider.dart';

class Machine {
  int row;
  int col;
  int velocity;
  Algorithm? algorithm;

  Machine({
    this.row = 0,
    this.col = 0,
    this.velocity = 100,
    this.algorithm = Algorithm.bfs,
  });

  Machine copyWith({
    int? row,
    int? col,
    int? velocity,
    int? score,
    Algorithm? algorithm,
    int? penalty,
  }) {
    return Machine(
      row: row ?? this.row,
      col: col ?? this.col,
      velocity: velocity ?? this.velocity,
      algorithm: algorithm ?? this.algorithm,
    );
  }
}
