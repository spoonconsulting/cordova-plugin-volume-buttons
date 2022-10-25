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
@end

@implementation CDVVolumeButtons

- (void)onPause {
    [self runBlockWithTryCatch:^{
        // Set session category to multi route as multiple volume/audio streams can be active at the same time
        self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryMultiRoute;
        [self.volumeButtonHandler stopHandler];
    }];
}

- (void)onResume {
    [self runBlockWithTryCatch:^{
        // Set session category to playback as it is the default used by JPSVolumeButtonHandler
        self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryPlayback;
        [self.volumeButtonHandler startHandler:YES];
    }];
}

- (void)start:(CDVInvokedUrlCommand*)command {
    [self runBlockWithTryCatch:^{
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(-1000, -1000, 100, 100)];
        [volumeView sizeToFit];
        [self.webView addSubview: volumeView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
        if (self.volumeButtonHandler == nil) {
            self.volumeButtonHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [pluginResult setKeepCallback:@YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } downBlock:^{
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [pluginResult setKeepCallback:@YES];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        }
        // Set session category to playback as it is the default used by JPSVolumeButtonHandler
        self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryPlayback;
        [self.volumeButtonHandler startHandler:YES];
    }];
}

- (void)stop:(CDVInvokedUrlCommand*)command {
    [self runBlockWithTryCatch:^{
        // Set session category to multi route as multiple volume/audio streams can be active at the same time
        self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryMultiRoute;
        [self.volumeButtonHandler stopHandler];
    }];
}

-(void)runBlockWithTryCatch:(void (^)(void))block {
    @try {
        block();
    } @catch (NSException *exception) {
        NSLog(@"CDVVolumeButtons Error %@", exception);
    }
}

@end
