import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/main.dart';
import 'package:lagorithms/src/providers/game_provider.dart';

class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const Text(
                'Aspiradora',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Velocidad', style: TextStyle(fontSize: 18)),
                  Flexible(
                    child: Slider(
                      value: ref.watch(machineProvider).velocity.toDouble(),
                      min: 100,
                      max: 1000,
                      divisions: 10,
                      onChanged: (v) {
                        ref
                            .watch(machineProvider.notifier)
                            .setVelocity(v.toInt());
                      },
                    ),
                  ),
                  Text(
                    ref.watch(machineProvider).velocity.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Piso',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Matriz', style: TextStyle(fontSize: 18)),
                  Flexible(
                    child: Slider(
                      value: sizes
                          .indexOf(ref.watch(settingsProvider).size)
                          .toDouble(),
                      max: sizes.length.toDouble() - 1,
                      divisions: sizes.length - 1,
                      onChanged: (v) {
                        ref
                            .watch(settingsProvider.notifier)
                            .setSize(sizes[v.toInt()]);
                        ref
                            .watch(machineProvider.notifier)
                            .validatePosition(ref.read(settingsProvider).size);
                      },
                    ),
                  ),
                  Text(
                    ref.watch(settingsProvider).size.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tamaño ', style: TextStyle(fontSize: 18)),
                  Flexible(
                    child: Slider(
                      value: ref.watch(settingsProvider).tileSize,
                      max: 50,
                      divisions: 50,
                      onChanged: (v) {
                        ref.watch(settingsProvider.notifier).setTileSize(v);
                      },
                    ),
                  ),
                  Text(
                    ref.watch(settingsProvider).tileSize.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Margen ', style: TextStyle(fontSize: 18)),
                  Flexible(
                    child: Slider(
                      value: ref.watch(settingsProvider).tileMargin,
                      max: 10,
                      divisions: 10,
                      onChanged: (v) {
                        ref.watch(settingsProvider.notifier).setTileMargin(v);
                      },
                    ),
                  ),
                  Text(
                    ref.watch(settingsProvider).tileMargin.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (ref.watch(gameProvider.notifier).isFinished) ...[
          TextButton(
            onPressed: () {
              ref.watch(gameProvider.notifier).reset();
            },
            child: Text('Reiniciar'),
          ),
        ],
        SizedBox(
          width: double.infinity,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Select Search Algorithm Dropdown
              Container(
                width: double.infinity,
                height: 50,
                child: DropdownButton<Algorithm>(
                  isExpanded: true,
                  value: ref.watch(machineProvider).algorithm,
                  onChanged: (Algorithm? newValue) {
                    ref.watch(machineProvider.notifier).setAlgorithm(newValue!);
                  },
                  items: Algorithm.values
                      .map<DropdownMenuItem<Algorithm>>(
                          (Algorithm value) => DropdownMenuItem<Algorithm>(
                                value: value,
                                child: Text(value.name.toString()),
                              ))
                      .toList(),
                ),
              ),

              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ref.watch(gameProvider.notifier).isFinished ||
                          ref.watch(gameProvider).isPlaying
                      ? null
                      : () {
                          ref.watch(gameProvider.notifier).play();
                          Navigator.pop(context);
                        },
                  child: ref.watch(gameProvider).isPlaying
                      ? const Text('Pausar')
                      : const Text('Iniciar'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
