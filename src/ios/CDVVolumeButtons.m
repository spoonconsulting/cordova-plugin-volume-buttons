#import <Cordova/CDV.h>
#import <JPSVolumeButtonHandler.h>

@interface CDVVolumeButtons : CDVPlugin {
  // Member variables go here.
}

- (void)start:(CDVInvokedUrlCommand*)command;
@property (nonatomic, strong) JPSVolumeButtonHandler *volumeButtonHandler;
@end

@implementation CDVVolumeButtons

- (void)start:(CDVInvokedUrlCommand*)command
{
    NSLog(@"ZAFIR");
    if (self.volumeButtonHandler == nil) {
        self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [pluginResult setKeepCallback:@YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } downBlock:^{
            // Volume Down Button Pressed
        }];
    }

    [self.volumeButtonHandler startHandler:YES]; 
}

@end
