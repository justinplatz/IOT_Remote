//
//  VideoController.h
//  IOTRemote
//
//  Created by Ryan Stern on 4/13/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *prevView;
@property (strong, nonatomic) IBOutlet UIView *playPauseView;
@property (strong, nonatomic) IBOutlet UIView *nextView;
@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) IBOutlet UIView *castView;
@property (strong, nonatomic) IBOutlet UIView *volumeDownView;
@property (strong, nonatomic) IBOutlet UIView *volumeUpView;


@property (strong, nonatomic) IBOutlet UIButton *playPauseChanger;
@property (strong, nonatomic) IBOutlet UIButton *homeDisabler;
@property (strong, nonatomic) IBOutlet UIButton *prevChanger;
@property (strong, nonatomic) IBOutlet UIButton *nextChanger;


- (IBAction)prevBtn:(UIButton *)sender;
- (IBAction)playPauseBtn:(UIButton *)sender;
- (IBAction)nextBtn:(UIButton *)sender;
- (IBAction)homeBtn:(UIButton *)sender;
- (IBAction)castBtn:(UIButton *)sender;
- (IBAction)volumeUpBtn:(UIButton *)sender;
- (IBAction)volumeDownBtn:(UIButton *)sender;


@end
