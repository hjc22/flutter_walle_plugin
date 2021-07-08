import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:args/src/usage.dart';
import 'package:args/args.dart';

void main(args) {
  var parser = new ArgParser.allowAnything();
  //  BuildApk buildApk = BuildApk()..build();
  var results = parser.parse(args);

  if (results.arguments.length == 0) {
    print(generateUsage([
      'setChannel        编译apk并写入渠道号 flutter pub run flutter_walle_plugin setChannel flutter build apk',
      'setInfo           编译apk并写入渠道信息 flutter pub run flutter_walle_plugin setInfo flutter build apk',
      'getInfo           查看指定apk文件渠道信息 flutter pub run flutter_walle_plugin getInfo /Users/hjc1/Documents/flutter/money_answer/channelApks/app-release_huawei.apk'
    ], lineLength: 5));
    return;
  }

  final command = results.arguments[0];
  final arguments = results.arguments.sublist(1);
  print('command: $command, arguments: $arguments');

  var build = BuildApk();
  List<String> list = [...arguments];
  list.remove('flutter');
  if (command == 'setChannel') {
    build.build(list);
  } else if (command == 'setInfo') {
    build.build(list, isSetInfo: true);
  } else if (command == 'getInfo') {
    if (arguments.first == null) {
      throw ArgumentError('没有apk文件路径，需要完整路径');
    }
    build.getApkInfo(arguments.first);
  } else {
    throw ArgumentError('没有选择命令');
  }
}

class BuildApk {
  /// 当前执行命令路径
  String dirName = path.context.current;

  /// jar文件路径
  String? jarFilePath;

  BuildApk() {
    var pluginPath = path.join(dirName, '.flutter-plugins');
    pluginPath = File(pluginPath)
        .readAsLinesSync()
        ?.firstWhere((String item) => item.contains('flutter_walle_plugin'));

    if (pluginPath != null) {
      jarFilePath =
          path.join(pluginPath, 'bin/walle-cli-all.jar').split('=')[1];
    }
  }

  /// 打包flutter 为apk
  build(List<String> args, {bool isSetInfo = false}) async {
    print('----------------------------编译开始----------------------------');
    Process.start('flutter', args).then((Process result) {
      result.stdout.transform(utf8.decoder).listen((data) {
        print(data);
      });
      bool isErr = false;
      result.stderr.transform(utf8.decoder).listen((data) {
        print(data);
        isErr = true;
      });

      result.exitCode.then((exitCode) {
        if (!isErr) {
          print('----------------------------编译成功----------------------------');
          setChannel(isSetInfo: isSetInfo);
        } else {
          print('----------------------------编译失败----------------------------');
        }
      });
    });
  }

  /// 写入渠道信息
  setChannel({List<String?>? args, bool isSetInfo = false}) {
    print('----------------------------写入渠道----------------------------');

    args ??= isSetInfo
        ? ['-jar', jarFilePath, 'batch2', '-f']
        : ['-jar', jarFilePath, 'batch', '-f'];

    var channelFilePath = isSetInfo
        ? path.join(dirName, 'channelInfo.json')
        : path.join(dirName, 'channel');

    if (!_checkFileExist(channelFilePath)) {
      throw ArgumentError(isSetInfo
          ? '写入渠道信息，需要在项目根目录新建渠道信息文件 [channelInfo.json]'
          : '写入渠道，需要在项目根目录新建渠道号文件 [channel]');
    }

    var apkDir = Directory(path.join(dirName, 'build/app/outputs/apk/release'));
    var list = apkDir.listSync();
    var channelDir = Directory(path.join(dirName, 'channelApks'));
    String newApkFileName;
    File apkFile;
    FileSystemEntity item = list.firstWhere((FileSystemEntity item) {
      return path.basename(item.path).contains('apk');
    });

    if (item != null) {
      apkFile = File(item.path);
      newApkFileName = path.join(channelDir.path, path.basename(apkFile.path));

      if (!channelDir.existsSync()) {
        channelDir.createSync();
      }
      print(newApkFileName);
      apkFile.copySync(newApkFileName);
    } else {
      throw ArgumentError('Directory $apkDir no apk file, build fail');
    }

    Process.run('java', [
      ...args as Iterable<String>,
      channelFilePath,
      path.join(dirName, newApkFileName)
    ]).then((ProcessResult result) {
      print('result----${result.stdout}');
      print('result----${result.stderr}');
    });
  }

  /// 查看apk的渠道信息
  getApkInfo(String apkFilePath) {
    Process.run('java', ['-jar', jarFilePath!, 'show', apkFilePath])
        .then((ProcessResult result) {
      print('result----${result.stdout}');
      print('result----${result.stderr}');
    });
  }

  /// 检查文件是否存在
  bool _checkFileExist(String filePath) {
    var file = File(filePath);
    return file.existsSync();
  }
}
