#import <Cordova/CDV.h>
#import "MediaPlayer/MPVolumeView.h"
#import <JPSVolumeButtonHandler.h>

@interface CDVVolumeButtons : CDVPlugin {
  // Member variables go here.
}

- (void)onPause;
- (void)onResume;
- (void)start:(CDVInvokedUrlCommand*)command;
- (void)stop:(CDVInvokedUrlCommand*)command;
@property (strong, nonatomic) JPSVolumeButtonHandler *volumeButtonHandler;
@property (nonatomic) float defaultVolume;
@property (strong, nonatomic) UISlider *volumeViewSlider;
@end

@implementation CDVVolumeButtons

- (void)onPause {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.volumeViewSlider.value = self.defaultVolume;
    });
    [self.volumeButtonHandler stopHandler];
}

- (void)onResume {
    self.defaultVolume = self.volumeViewSlider.value;
    [self.volumeButtonHandler startHandler:YES];
}

- (void)start:(CDVInvokedUrlCommand*)command {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in volumeView.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (self.volumeButtonHandler == nil) {
        self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.volumeViewSlider.value = 0.9f;
            });
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [pluginResult setKeepCallback:@YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } downBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.volumeViewSlider.value = 0.1f;
            });
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [pluginResult setKeepCallback:@YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    self.defaultVolume = self.volumeViewSlider.value;
    [self.volumeButtonHandler startHandler:YES];
}

- (void)stop:(CDVInvokedUrlCommand*)command {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.volumeViewSlider.value = self.defaultVolume;
    });
    [self.volumeButtonHandler stopHandler];
}

@end
