/********* cordova-plugin-volume-buttons.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface cordova-plugin-volume-buttons : CDVPlugin {
  // Member variables go here.
}

- (void)start:(CDVInvokedUrlCommand*)command;
@end

@implementation cordova-plugin-volume-buttons

- (void)start:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
