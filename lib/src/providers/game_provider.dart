import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/main.dart';
import 'package:lagorithms/src/models/floor.dart';
import 'package:lagorithms/src/models/game.dart';
import 'package:lagorithms/src/models/machine.dart';
import 'package:lagorithms/src/models/target.dart';

enum Algorithm { dfs, bfs, aStar }

class GameProvider extends StateNotifier<BacuumGame> {
  Ref ref;
  GameProvider(BacuumGame value, this.ref) : super(value) {
    toVisit = [(machine.row, machine.col)];
  }

  Algorithm? get algorithm => machine.algorithm;
  List<(int, int)> toVisit = [];

  Map<(int, int), bool> dp = {};

  Machine get machine => ref.read(machineProvider);
  Floor get floor => ref.read(floorProvider);
  Target get target => ref.read(targetProvider);
  bool get isFinished => toVisit.isEmpty;

  reset() {
    toVisit = [(machine.row, machine.col)];
    dp = {};
    state = state.copyWith(isPlaying: false);
    ref.read(machineProvider.notifier).reset();
    ref.read(floorProvider.notifier).reset();
  }

  play() async {
    if (state.isPlaying) return;

    switch (algorithm) {
      case Algorithm.dfs:
        await dfs();
        break;
      case Algorithm.bfs:
        await bfs();
        break;
      case Algorithm.aStar:
        await aStar();
        break;
      default:
        break;
    }

    return true;
  }

  Future<void> bfs() async {
    int row = machine.row;
    int col = machine.col;
    toVisit = [(row, col)];

    while (toVisit.isNotEmpty) {
      var (row, col) = toVisit.removeAt(0);
      if (dp[(row, col)] == true) continue;

      ref.read(floorProvider.notifier).setVisited(row: row, col: col);
      dp[(row, col)] = true;

      await Future.delayed(Duration(milliseconds: 50));
      var neighbors = getNeighbors(col, row);

      if (target.col == col && target.row == row) {
        toVisit = [];
        state = state.copyWith(isPlaying: false);
        return;
      }

      for (var (r, c) in neighbors) {
        toVisit.add((r, c));
      }
    }
  }

  Future<void> dfs() async {
    int row = machine.row;
    int col = machine.col;
    toVisit = [(row, col)];

    while (toVisit.isNotEmpty) {
      var (row, col) = toVisit.removeLast();
      if (dp[(row, col)] == true) continue;

      ref.read(floorProvider.notifier).setVisited(row: row, col: col);
      dp[(row, col)] = true;

      await Future.delayed(Duration(milliseconds: 50));
      var neighbors = getNeighbors(col, row);

      if (target.col == col && target.row == row) {
        toVisit = [];
        state = state.copyWith(isPlaying: false);
        return;
      }

      for (var (r, c) in neighbors) {
        toVisit.add((r, c));
      }
    }
  }

  Future<void> aStar() async {
    int row = machine.row;
    int col = machine.col;
    toVisit = [(row, col)];

    while (toVisit.isNotEmpty) {
      var (row, col) = toVisit.removeLast();
      if (dp[(row, col)] == true) continue;

      ref.read(floorProvider.notifier).setVisited(row: row, col: col);
      dp[(row, col)] = true;

      await Future.delayed(Duration(milliseconds: 50));
      var neighbors = getNeighbors(col, row);

      if (target.col == col && target.row == row) {
        toVisit = [];
        state = state.copyWith(isPlaying: false);
        return;
      }

      for (var (r, c) in neighbors) {
        toVisit.add((r, c));
      }
    }
  }

  List<(int, int)> getNeighbors(int col, int row) {
    List<(int, int)> neighbors = [];
    if (row > 0) neighbors.add((row - 1, col));
    if (row < state.rows - 1) neighbors.add((row + 1, col));
    if (col > 0) neighbors.add((row, col - 1));
    if (col < state.cols - 1) neighbors.add((row, col + 1));

    neighbors.removeWhere((e) =>
        dp[e] == true ||
        ref.watch(floorProvider.notifier).isWall(row: e.$1, col: e.$2));
    return neighbors;
  }
}
