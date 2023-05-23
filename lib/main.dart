import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/src/game/engine.dart';
import 'package:lagorithms/src/models/floor.dart';
import 'package:lagorithms/src/models/floor_size.dart';
import 'package:lagorithms/src/models/game.dart';
import 'package:lagorithms/src/models/game_settings.dart';
import 'package:lagorithms/src/models/machine.dart';
import 'package:lagorithms/src/models/target.dart';
import 'package:lagorithms/src/providers/floor_provider.dart';
import 'package:lagorithms/src/providers/game_provider.dart';
import 'package:lagorithms/src/providers/machine_provider.dart';
import 'package:lagorithms/src/providers/settings_provider.dart';
import 'package:lagorithms/src/providers/target_provider.dart';
import 'package:lagorithms/src/widgets/configurations_game.dart';

// Providers
final floorProvider = StateNotifierProvider<FloorProvider, Floor>((ref) {
  var settings = ref.watch(settingsProvider);
  return FloorProvider(Floor(settings.size));
});

final machineProvider = StateNotifierProvider<MachineProvider, Machine>(
    (ref) => MachineProvider(Machine()));

final targetProvider = StateNotifierProvider<TargetProvider, Target>(
  (ref) => TargetProvider(Target(col: 9, row: 9)),
);

final settingsProvider = StateNotifierProvider<SettingsProvider, GameSettings>(
    (ref) => SettingsProvider(GameSettings(size: sizes[0]), ref));

final gameProvider = StateNotifierProvider<GameProvider, BacuumGame>(
  (ref) => GameProvider(
    BacuumGame(
      settings: ref.watch(settingsProvider),
    ),
    ref,
  ),
);

List<FloorSize> sizes = [
  FloorSize(rows: 10, cols: 10),
  FloorSize(rows: 15, cols: 15),
  FloorSize(rows: 20, cols: 20),
  FloorSize(rows: 25, cols: 25),
  FloorSize(rows: 30, cols: 30),
];

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      title: 'Material App',
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Search Algorithms'),
            ),
            drawer: ConfigurationsGame(),
            body: GameWidget(
              game: BacuumGameWidget(ref.read(gameProvider), ref),
            ),
          );
        },
      ),
    );
  }
}
