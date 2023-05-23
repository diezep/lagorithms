import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/main.dart';
import 'package:lagorithms/src/models/floor_size.dart';
import 'package:lagorithms/src/models/game_settings.dart';

class SettingsProvider extends StateNotifier<GameSettings> {
  SettingsProvider(GameSettings value, this.ref) : super(value);

  final Ref ref;

  void setTileSize(double value) {
    state = state.copyWith(tileSize: value);
  }

  void setTileMargin(double value) {
    state = state.copyWith(tileMargin: value);
  }

  void setTileRadius(double value) {
    state = state.copyWith(tileRadius: value);
  }

  void setSize(FloorSize value) {
    ref.read(floorProvider.notifier).setSize(value);
    state = state.copyWith(size: value);
  }

  void setDirtRate(double value) {
    state = state.copyWith(dirtRate: value);
  }

  void randomize() {
    var rand = Random();

    ref.read(machineProvider.notifier).move(
          row: rand.nextInt(state.size.rows),
          col: rand.nextInt(state.size.cols),
        );
  }
}
