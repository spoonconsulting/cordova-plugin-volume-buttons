// Sample Code from JPSVolumeButtonHandler(https://github.com/jpsim/JPSVolumeButtonHandler)

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CDVVolumeButtonBlock)(void);

@interface CDVVolumeButtonsController : NSObject

// A block to run when the volume up button is pressed
@property (nonatomic, copy) CDVVolumeButtonBlock upBlock;

// A block to run when the volume down button is pressed
@property (nonatomic, copy) CDVVolumeButtonBlock downBlock;

// A shared audio session category
@property (nonatomic, strong) NSString * sessionCategory;

@property (nonatomic, assign) AVAudioSessionCategoryOptions sessionOptions;

- (void)startHandler:(BOOL)disableSystemVolumeHandler;
- (void)stopHandler;

// A Function to set exactJumpsOnly.  When set to YES, only volume jumps of .0625 call the code blocks.
// If it doesn't match, the code blocks are not called and setInitialVolume is called
- (void)useExactJumpsOnly:(BOOL)enabled;

// Returns a button handler with the specified up/down volume button blocks
+ (instancetype)volumeButtonHandlerWithUpBlock:(CDVVolumeButtonBlock)upBlock downBlock:(CDVVolumeButtonBlock)downBlock;

@end
