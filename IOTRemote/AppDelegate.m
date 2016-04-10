//
//  AppDelegate.m
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    PNConfiguration *configuration = [
                                      PNConfiguration configurationWithPublishKey:@"pub-c-f83b8b34-5dbc-4502-ac34-5073f2382d96"
                                      subscribeKey:@"sub-c-34be47b2-f776-11e4-b559-0619f8945a4f"];
    
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    [self.client subscribeToChannels: @[@"light_channel"] withPresence:NO];
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    

    
    return YES;
}

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    NSLog(@"Received message: %@ on channel %@ at %@", message.data.message,
          message.data.subscribedChannel, message.data.timetoken);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event { switch (event.subtype) { case UIEventSubtypeRemoteControlPlay:
        // handle it break;
    case UIEventSubtypeRemoteControlPause: // handle it break;
    case UIEventSubtypeRemoteControlNextTrack: // handle it break;
    case UIEventSubtypeRemoteControlPreviousTrack: // handle it break;
    default: break; }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
