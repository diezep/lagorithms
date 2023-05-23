import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/src/models/floor.dart';
import 'package:lagorithms/src/models/floor_cell.dart';
import 'package:lagorithms/src/models/floor_size.dart';

class FloorProvider extends StateNotifier<Floor> {
  FloorProvider(Floor value) : super(value);

  void reset() {
    state = state.copyWith(
      cells: state.cells.map((row) {
        return row.map((cell) {
          return cell.copyWith(
            dirty: TileType.clean,
            isVisited: false,
          );
        }).toList();
      }).toList(),
    );
  }

  void toggleWall({required int col, required int row}) {
    state.cells[row][col] = state.cells[row][col].copyWith(
      dirty: state.cells[row][col].dirty == TileType.clean
          ? TileType.wall
          : TileType.clean,
    );
  }

  void setSize(FloorSize size) => state = Floor(size);

  void setVisited({required int row, required int col}) {
    var newState = state.copyWith();

    newState.cells[row][col] = newState.cells[row][col].copyWith(
      isVisited: true,
    );

    state = newState;
  }

  bool isVisited({required int row, required int col}) {
    return state.cells[row][col].isVisited;
  }

  bool isWall({required int row, required int col}) {
    return state.cells[row][col].dirty == TileType.wall;
  }
}
