import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/providers/global_loader.dart';

//シングルトンにしてアプリ全体で共通化
class LoadingManager {
  static final LoadingManager _instance = LoadingManager._internal();

  LoadingManager._internal();

  static LoadingManager get instance => _instance;

  void startLoading(WidgetRef ref) {
    ref.read(globalLoaderProvider.notifier).setLoaderValue(true);
  }

  void stopLoading(WidgetRef ref) {
    ref.read(globalLoaderProvider.notifier).setLoaderValue(false);
  }
}
