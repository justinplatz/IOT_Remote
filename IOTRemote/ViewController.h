//
//  ViewController.h
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <PubNub/PubNub.h>

@interface ViewController : UIViewController
-(void)setAllViewsToGrayBackground;
-(void)addBordersToViews;
-(void)playClickSound;
-(void)disableButtonTemporarily;
@property (nonatomic) PubNub *client;
@end

