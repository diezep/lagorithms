import 'package:lagorithms/src/models/floor.dart';
import 'package:lagorithms/src/models/game_settings.dart';
import 'package:lagorithms/src/models/machine.dart';

class BacuumGame {
  bool isPlaying = false;
  GameSettings settings;

  int get rows => settings.rows;
  int get cols => settings.cols;

  BacuumGame({
    required this.settings,
    this.isPlaying = false,
  });

  BacuumGame copyWith({
    bool? isPlaying,
    Floor? floor,
    Machine? vacuum,
    GameSettings? settings,
  }) {
    return BacuumGame(
      isPlaying: isPlaying ?? this.isPlaying,
      settings: settings ?? this.settings,
    );
  }
}
