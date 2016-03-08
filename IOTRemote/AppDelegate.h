//
//  AppDelegate.h
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PubNub/PubNub.h>

#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) PubNub *client;
@end

