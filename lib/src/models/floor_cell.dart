class FloorCell {
  final int row, col;

  bool isWall;
  bool isVisited = false;
  TileType dirty = TileType.clean;

  FloorCell(
    this.row,
    this.col, {
    this.isVisited = false,
    this.isWall = false,
    this.dirty = TileType.clean,
  });

  FloorCell copyWith({
    bool? isWall,
    TileType? dirty,
    bool? isVisited,
  }) {
    return FloorCell(
      row,
      col,
      isVisited: isVisited ?? this.isVisited,
      isWall: isWall ?? this.isWall,
      dirty: dirty ?? this.dirty,
    );
  }
}

enum TileType {
  clean,
  wall,
}
