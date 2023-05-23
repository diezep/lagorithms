import 'package:lagorithms/src/models/floor_cell.dart';
import 'package:lagorithms/src/models/floor_size.dart';

class Floor {
  List<List<FloorCell>> cells;

  Floor(FloorSize size) : cells = generateCells(size);

  int get rows => cells.length;
  int get cols => cells[0].length;

  static List<List<FloorCell>> generateCells(FloorSize size) {
    return List.generate(
      size.rows,
      (row) => List.generate(
        size.cols,
        (col) => FloorCell(
          row,
          col,
          isWall: row == 0 ||
              row == size.rows - 1 ||
              col == 0 ||
              col == size.cols - 1,
        ),
      ),
    );
  }

  Floor copyWith({
    List<List<FloorCell>>? cells,
  }) {
    return Floor(
      FloorSize(rows: rows, cols: cols),
    )..cells = cells ?? this.cells;
  }
}
