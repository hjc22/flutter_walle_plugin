#import "FlutterWallePlugin.h"
#import <flutter_walle_plugin/flutter_walle_plugin-Swift.h>

@implementation FlutterWallePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWallePlugin registerWithRegistrar:registrar];
}
@end
