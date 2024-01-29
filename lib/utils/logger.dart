import 'package:logger/logger.dart';

class AppLogger {
  // プライベートなコンストラクタ
  AppLogger._internal();

  // クラスの唯一のインスタンス
  static final AppLogger _instance = AppLogger._internal();

  // Loggerインスタンス
  final Logger _logger = Logger();

  // インスタンスへのアクセス用の公開されたゲッター
  static AppLogger get instance => _instance;

  // Loggerの各種メソッドへのラッパー
  void log(String message) => _logger.d(message);

  void info(String message) => _logger.i(message);

  void warning(String message) => _logger.w(message);

  void error(String message) => _logger.e(message);
}
