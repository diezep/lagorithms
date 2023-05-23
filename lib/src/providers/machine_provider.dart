import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/src/models/floor_size.dart';
import 'package:lagorithms/src/models/machine.dart';
import 'package:lagorithms/src/providers/game_provider.dart';

class MachineProvider extends StateNotifier<Machine> {
  MachineProvider(Machine value) : super(value);

  Algorithm? get algorithm => state.algorithm;

  void reset() {
    state = state.copyWith(
      row: 0,
      col: 0,
      score: 0,
      penalty: 0,
    );
  }

  void setVelocity(int velocity) {
    state = state.copyWith(velocity: velocity);
  }

  void addPosition(int col, int row) {
    state = state.copyWith(col: state.col + col, row: state.row + row);
  }

  void move({int? row, int? col}) {
    state = state.copyWith(
      row: row,
      col: col,
    );
  }

  void validatePosition(FloorSize size) {
    if (state.row < 0) {
      state = state.copyWith(row: 0);
    } else if (state.row >= size.rows) {
      state = state.copyWith(row: size.rows - 1);
    }

    if (state.col < 0) {
      state = state.copyWith(col: 0);
    } else if (state.col >= size.cols) {
      state = state.copyWith(col: size.cols - 1);
    }
  }

  void setAlgorithm(Algorithm algorithm) {
    state = state.copyWith(algorithm: algorithm);
  }
}
