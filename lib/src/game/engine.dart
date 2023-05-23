import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart' hide Draggable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/main.dart';
import 'package:lagorithms/src/models/floor.dart';
import 'package:lagorithms/src/models/floor_cell.dart';
import 'package:lagorithms/src/models/game.dart';
import 'package:lagorithms/src/models/game_settings.dart';
import 'package:lagorithms/src/models/machine.dart';
import 'package:lagorithms/src/models/target.dart';

class BacuumGameWidget extends FlameGame
    with HasTappables, HasDraggables, HasHoverables, HasComponentRef {
  BacuumGameWidget(this.game, WidgetRef ref) {
    HasComponentRef.widgetRef = ref;
  }
  BacuumGame game;
  FloorComponent? floorComponent;
  @override
  void onMount() async {
    super.onMount();
    add(floorComponent = FloorComponent(
      position: Vector2.all(0),
      size: size,
    ));
  }
}

class FloorComponent extends PositionComponent with HasComponentRef {
  FloorComponent({
    super.position,
    super.size,
    super.anchor = Anchor.center,
  });

  final paint = Paint()..color = Colors.white;

  int _rows = 0;
  int _cols = 0;
  double _tileSize = 0;
  double _tileMargin = 0;
  Vector2 _vacuumPosition = Vector2.zero();
  List<List<FloorTileComponent>> _tiles = [];

  GameSettings get settings => ref.read(settingsProvider);
  Machine get vacuum => ref.read(machineProvider);
  Target get target => ref.read(targetProvider);

  Floor get floor => ref.read(floorProvider);

  List<List<FloorTileComponent>> generateTiles() {
    _rows = settings.rows;
    _cols = settings.cols;
    _tileSize = settings.tileSize;
    _tileMargin = settings.tileMargin;
    double tileSize = _tileMargin + _tileSize;

    _vacuumPosition = Vector2(vacuum.col.toDouble(), vacuum.row.toDouble());
    Vector2 _targetPosition = Vector2(
      target.col.toDouble(),
      target.row.toDouble(),
    );
    var cells = floor.cells;

    return List.generate(
      _rows,
      (i) => List.generate(
        _cols,
        (j) => FloorTileComponent(
          position: Vector2(
            (j * tileSize) + (tileSize / 2) + size.x - (_cols * tileSize) / 2,
            (i * tileSize) + (tileSize / 2) + size.y - (_rows * tileSize) / 2,
          ),
          size: Vector2.all(_tileSize),
          cell: cells[i][j],
          hasMachine: i == _vacuumPosition.y && j == _vacuumPosition.x,
          hasTarget: i == _targetPosition.y && j == _targetPosition.x,
          floorSize: size,
        ),
      ),
    );
  }

  @override
  void onMount() {
    super.onMount();

    listen(settingsProvider, (p0, settings) {
      removeAll(_tiles.expand((element) => element).toList());

      _tiles = generateTiles();
      addAll(_tiles.expand((element) => element).toList());
    });

    listen(floorProvider, (_, _floor) {
      removeAll(children);

      _tiles = generateTiles();
      addAll(_tiles.expand((element) => element).toList());
    });
  }
}

class FloorTileComponent extends PositionComponent
    with Tappable, Hoverable, Draggable, HasComponentRef {
  FloorTileComponent({
    super.position,
    super.size,
    required this.cell,
    super.anchor = Anchor.center,
    required this.floorSize,
    this.hasMachine = false,
    this.hasTarget = false,
  });
  bool hasMachine;
  bool hasTarget;
  FloorCell cell;
  Vector2 floorSize;
  late TileType dirtyLevel;

  Paint paint = Paint()..color = Colors.white;
  Paint wallPaint = Paint()..color = Colors.grey.shade900;
  Paint machinePaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.fill;

  int get row => cell.row;
  int get col => cell.col;

  Floor get floor => ref.read(floorProvider);
  Machine get machine => ref.read(machineProvider);

  @override
  void render(Canvas canvas) {
    dirtyLevel = floor.cells[row][col].dirty;
    hasMachine = machine.row == row && machine.col == col;

    super.render(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        size.toRect(),
        const Radius.circular(0),
      ),
      paint,
    );
    if (hasMachine) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          size.toRect().deflate(size.x),
          const Radius.circular(3),
        ),
        machinePaint,
      );
    } else if (dirtyLevel != TileType.clean) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          (size).toRect().deflate(size.x),
          const Radius.circular(3),
        ),
        wallPaint,
      );
    }

    if (cell.isVisited) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          size.toRect().deflate(size.x / 1.2),
          const Radius.circular(3),
        ),
        machinePaint,
      );
    }

    if (hasTarget) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          size.toRect().deflate(size.x),
          const Radius.circular(3),
        ),
        machinePaint..color = Colors.red,
      );
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    ref.read(floorProvider.notifier).toggleWall(row: row, col: col);
    return super.onTapDown(info);
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    paint.color = Colors.grey.shade300;
    return super.onHoverEnter(info);
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    paint.color = Colors.white;
    return super.onHoverLeave(info);
  }

  Vector2? _dragStart;
  @override
  bool onDragStart(DragStartInfo info) {
    if (hasMachine || hasTarget) _dragStart = info.eventPosition.game;

    return super.onDragStart(info);
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (_dragStart == null) return super.onDragUpdate(info);
    var delta = info.eventPosition.game - _dragStart!;

    if ((delta.x ~/ size.x).abs() > 0 || (delta.y ~/ size.y).abs() > 0) {
      var newRow = row + (delta.y / size.y);
      var newCol = col + (delta.x / size.x);
      // if (hasMachine) {
      // ref
      //     .read(machineProvider.notifier)
      //     .move(row: newRow.round(), col: newCol.round());
      // }
      // if (hasTarget) {
      ref
          .read(targetProvider.notifier)
          .move(row: newRow.round(), col: newCol.round());
      // }
    }
    return super.onDragUpdate(info);
  }
}

Vector2 calculateTilePosition(
    Vector2 mouse, Vector2 tileSize, Vector2 floorSize) {
  int _cols = floorSize.x ~/ (tileSize.x + 5);
  int _rows = floorSize.y ~/ (tileSize.y + 5);

  // (j * tileSize) + (tileSize / 2) + size.x - (_cols * tileSize) / 2,
  // (i * tileSize) + (tileSize / 2) + size.y - (_rows * tileSize) / 2,
  var x = (mouse.x - floorSize.x / 2) / tileSize.x;
  var y = (mouse.y - floorSize.y / 2) / tileSize.y;
  return Vector2(x, y);
}
