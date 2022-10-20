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
    
    // Set session category to multi route as multiple volume/audio streams can be active at the same time
    self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryMultiRoute;
    [self.volumeButtonHandler stopHandler];
}

- (void)onResume {
    // Set session category to playback as it is the default used by JPSVolumeButtonHandler
    self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryPlayback;
    [self.volumeButtonHandler startHandler:YES];
}

- (void)start:(CDVInvokedUrlCommand*)command {
    [self runBlockWithTryCatch:^{
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
    } forCommand:command];
}

- (void)stop:(CDVInvokedUrlCommand*)command {
    [self runBlockWithTryCatch:^{
        // Set session category to multi route as multiple volume/audio streams can be active at the same time
        self.volumeButtonHandler.sessionCategory = AVAudioSessionCategoryMultiRoute;
        [self.volumeButtonHandler stopHandler];
    } forCommand:command];
}

-(void)runBlockWithTryCatch:(void (^)(void))block forCommand:(CDVInvokedUrlCommand*)command{
    @try {
        block();
    } @catch (NSException *exception) {
        NSLog(@"CDVVolumeButtons Error %@", exception);
    }
}

@end
