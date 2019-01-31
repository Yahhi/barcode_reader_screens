#import "BarcodeLibPlugin.h"
#import <barcode_lib/barcode_lib-Swift.h>

@implementation BarcodeLibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBarcodeLibPlugin registerWithRegistrar:registrar];
}
@end
