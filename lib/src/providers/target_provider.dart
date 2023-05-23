import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/src/models/target.dart';

class TargetProvider extends StateNotifier<Target> {
  TargetProvider(Target value) : super(value);

  void move({required int row, required int col}) {
    state = state.copyWith(row: row, col: col);
  }
}
