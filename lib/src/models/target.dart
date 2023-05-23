class Target {
  int row;
  int col;

  Target({required this.row, required this.col});

  Target copyWith({
    int? row,
    int? col,
  }) {
    return Target(
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }
}
