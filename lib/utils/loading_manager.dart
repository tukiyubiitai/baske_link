import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/providers/global_loader.dart';

class LoadingManager {
  void startLoading(WidgetRef ref) {
    ref.read(globalLoaderProvider.notifier).setLoaderValue(true);
  }

  void stopLoading(WidgetRef ref) {
    ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
  }
}
