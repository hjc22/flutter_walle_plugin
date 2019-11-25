import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_walle_plugin/flutter_walle_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.hjc.com/flutter_walle_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'vivo';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getWalleChannel', () async {
    expect(await FlutterWallePlugin.getWalleChannel(), 'vivo');
  });
}
