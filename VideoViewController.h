//
//  VideoViewController.h
//  IOTRemote
//
//  Created by Jin  on 4/9/16.
//  Copyright © 2016 ioJP. All rights reserved.
//


#import "YTPlayerView.h"


@interface VideoViewController: UIViewController<YTPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

- (IBAction)playButton:(UIButton *)sender;

- (IBAction)nextButton:(UIButton *)sender;

- (IBAction)previousButton:(UIButton *)sender;
- (IBAction)Home:(UIButton *)sender;
- (IBAction)cast:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *previousView;

@property (strong, nonatomic) IBOutlet UIView *nextView;

@property (strong, nonatomic) IBOutlet UIView *playView;

@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) IBOutlet UIView *castView;

@end