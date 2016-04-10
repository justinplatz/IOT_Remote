//
//  VideoViewController.m
//  IOTRemote
//
//  Created by Jin  on 4/9/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "VideoViewController.h"
#import "UIColor+IOTRemote_Colors.h"


@implementation VideoViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBordersToViews];

    NSString* playlistId = @"PLhBgTdAWkxeCMHYCQ0uuLyhydRJGDRNo5";
    
    // For a full list of player parameters, see the documentation for the HTML5 player
    // at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5
    NSDictionary *playerVars = @{
                                 @"controls" : @0,
                                 @"playsinline" : @1,
                                 @"autohide" : @1,
                                 @"showinfo" : @0,
                                 @"modestbranding" : @1
                                 };
    self.playerView.delegate = self;
    
    [self.playerView loadWithPlaylistId:playlistId playerVars:playerVars];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedPlaybackStartedNotification:)
                                                 name:@"Playback started"
                                               object:nil];
}


- (IBAction)pauseButton:(UIButton *)sender {
    [self.playerView pauseVideo];
}

- (IBAction)playButton:(UIButton *)sender {
    [self.playerView playVideo];
}

- (IBAction)nextButton:(UIButton *)sender {
    [self.playerView nextVideo];
}

- (IBAction)previousButton:(UIButton *)sender {
    [self.playerView previousVideo];
}

- (IBAction)Home:(UIButton *)sender {
}

- (IBAction)cast:(UIButton *)sender {
}


-(void)addBordersToViews{
    self.previousView.layer.backgroundColor = [UIColor sunsetOrange].CGColor;
    
    self.playView.layer.backgroundColor = [UIColor emerald].CGColor;
    
    self.nextView.layer.backgroundColor = [UIColor babyBlue].CGColor;
    
    
    self.homeView.layer.backgroundColor = [UIColor whiteSmoke].CGColor;
    
    self.castView.layer.backgroundColor = [UIColor darkBlueColor].CGColor;
    
}

@end