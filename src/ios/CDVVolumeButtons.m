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
    [self.volumeButtonHandler stopHandler];
}

- (void)onResume {
    AVAudioSession *avAudioSession = AVAudioSession.sharedInstance;
    self.defaultVolume = avAudioSession.outputVolume;
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
    AVAudioSession *avAudioSession = AVAudioSession.sharedInstance;
    self.defaultVolume = avAudioSession.outputVolume;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (self.volumeButtonHandler == nil) {
        self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
            self.volumeViewSlider.value = self.defaultVolume;
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [pluginResult setKeepCallback:@YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } downBlock:^{
            self.volumeViewSlider.value = self.defaultVolume;
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [pluginResult setKeepCallback:@YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    [self.volumeButtonHandler startHandler:YES];
}

- (void)stop:(CDVInvokedUrlCommand*)command {
    [self.volumeButtonHandler stopHandler];
}

@end
