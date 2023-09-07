#import <Cordova/CDV.h>
#import "MediaPlayer/MPVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CDVVolumeButtons : CDVPlugin {
  // Member variables go here.
}

@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) NSString *sessionCategory;
@property (nonatomic, assign) float userVolume;
@property (nonatomic, assign) bool isAdjustingInitialVolume;
@property (nonatomic, assign) bool appIsActive;
@property (nonatomic, assign) AVAudioSessionCategoryOptions sessionOptions;
@property (nonatomic) NSString *onVolumeButtonPressedHandlerId;
@end

@implementation CDVVolumeButtons

static void *sessionContext = &sessionContext;

- (void)onPause {
    [self runBlockWithTryCatch:^{
        [self removeListenersAndObservers];
    }];
}

- (void)onResume {
    [self runBlockWithTryCatch:^{
        [self setupAudioSession];
        [self setVolume];
    }];
}

- (void)start:(CDVInvokedUrlCommand*)command {
    [self runBlockWithTryCatch:^{
        self.onVolumeButtonPressedHandlerId = command.callbackId;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [self setupAudioSession];
        self.userVolume = self.session.outputVolume;
        [self setVolume];
    }];
}

- (void)stop:(CDVInvokedUrlCommand*)command {
    [self runBlockWithTryCatch:^{
        [self removeListenersAndObservers];
    }];
}

- (void)removeListenersAndObservers {
    if (!self.appIsActive) return;

    self.appIsActive = NO;
    @try {
        [self.session removeObserver:self forKeyPath:@"outputVolume"];
    }
    @catch (NSException * __unused exception) {
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupAudioSession {
    self.sessionCategory = AVAudioSessionCategoryPlayback;
    self.sessionOptions = AVAudioSessionCategoryOptionMixWithOthers;
    self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0)];

    [[UIApplication sharedApplication].windows.firstObject addSubview:self.volumeView];

    self.volumeView.hidden = NO;
    self.session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.session setCategory:self.sessionCategory
                  withOptions:self.sessionOptions
                        error:&error];
    [self.session setActive:YES error:&error];
    [self.session addObserver:self
                   forKeyPath:@"outputVolume"
                      options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                      context:sessionContext];
    self.appIsActive = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterrupted:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidChangeActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidChangeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)audioSessionInterrupted:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    switch (interuptionType) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"Audio Session Interruption case started.", nil);
            break;
        case AVAudioSessionInterruptionTypeEnded:
        {
            NSLog(@"Audio Session Interruption case ended.", nil);
            NSError *error = nil;
            [self.session setActive:YES error:&error];
            if (error) {
                NSLog(@"%@", error);
            }
            break;
        }
        default:
            NSLog(@"Audio Session Interruption Notification case default.", nil);
            break;
    }
}

- (void)applicationDidChangeActive:(NSNotification *)notification {
    self.appIsActive = [notification.name isEqualToString:UIApplicationDidBecomeActiveNotification];
    if (self.appIsActive) {
        [self setVolume];
    }
}

- (void)setVolume {
    float currentVolume = self.session.outputVolume;
    
    if (currentVolume >= 0.80000 || currentVolume <= 0.20000) {
        self.isAdjustingInitialVolume = true;
        [self setSystemVolume:0.50000];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == sessionContext) {
        if (!self.appIsActive) return;

        if (self.isAdjustingInitialVolume) {
            self.isAdjustingInitialVolume = false;
            [self setVolume];
            return;
        }
        [self callback];
        [self setVolume];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)callback {
    [self runBlockWithTryCatch:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallback:@YES];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.onVolumeButtonPressedHandlerId];
    }];
}

- (void)setSystemVolume:(CGFloat)volume {
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:(float)volume];
}

-(void)runBlockWithTryCatch:(void (^)(void))block {
    @try {
        block();
    } @catch (NSException *exception) {
        NSLog(@"CDVVolumeButtons Error %@", exception);
    }
}

@end
