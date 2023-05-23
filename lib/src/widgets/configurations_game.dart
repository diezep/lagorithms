import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lagorithms/src/widgets/settings_drawer.dart';

class ConfigurationsGame extends ConsumerWidget {
  const ConfigurationsGame({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Drawer(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 12, bottom: 20),
                child: SettingsDrawer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
