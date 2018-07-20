#import "KeyboardHeightPlugin.h"
#import <keyboard_height/keyboard_height-Swift.h>

@implementation KeyboardHeightPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKeyboardHeightPlugin registerWithRegistrar:registrar];
}
@end
