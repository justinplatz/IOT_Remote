//
//  ViewController+MusicViewController.m
//  IOTRemote
//
//  Created by Justin Platz on 3/30/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "MusicViewController.h"
#import "GVMusicPlayerController/GVMusicPlayerController.h"
#import "UIColor+IOTRemote_Colors.h"
@interface MusicViewController ()

@property (strong, nonatomic) IBOutlet UIView *backwardView;
@property (strong, nonatomic) IBOutlet UIView *playpauseView;
@property (strong, nonatomic) IBOutlet UIView *nextView;

@property (strong, nonatomic) IBOutlet UIView *posistionView;
@property (strong, nonatomic) IBOutlet UIView *songArtView;
@property (strong, nonatomic) IBOutlet UIView *songInfoView;

@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) IBOutlet UIView *volumeUpView;
@property (strong, nonatomic) IBOutlet UIView *volumeDownView;
@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;

@property (nonatomic, assign) BOOL songIsPlaying;


@end

@implementation MusicViewController : UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBordersToViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GVMusicPlayerController sharedInstance] addDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[GVMusicPlayerController sharedInstance] removeDelegate:self];
    [super viewDidDisappear:animated];
}

-(void)addBordersToViews{
    self.backwardView.layer.borderColor = [UIColor lightYellowColor].CGColor;
    self.backwardView.layer.borderWidth = 20.0f;
    
    self.playpauseView.layer.borderColor = [UIColor darkBlueColor].CGColor;
    self.playpauseView.layer.borderWidth = 20.0f;
    
    self.nextView.layer.borderColor = [UIColor darkRedColor].CGColor;
    self.nextView.layer.borderWidth = 20.0f;
    
    self.posistionView.layer.borderColor = [UIColor lightGreenColor].CGColor;
    self.posistionView.layer.borderWidth = 20.0f;
    
    self.songInfoView.layer.borderColor = [UIColor lightGreenColor].CGColor;
    self.songInfoView.layer.borderWidth = 20.0f;
    
    self.songArtView.layer.borderColor = [UIColor lightBlueColor].CGColor;
    self.songArtView.layer.borderWidth = 20.0f;
    
    self.homeView.layer.borderColor = [UIColor lightYellowColor].CGColor;
    self.homeView.layer.borderWidth = 20.0f;
    
    self.volumeUpView.layer.borderColor = [UIColor darkBlueColor].CGColor;
    self.volumeUpView.layer.borderWidth = 20.0f;
    
    self.volumeDownView.layer.borderColor = [UIColor darkRedColor].CGColor;
    self.volumeDownView.layer.borderWidth = 20.0f;
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState {
    self.playPauseButton.selected = (playbackState == MPMusicPlaybackStatePlaying);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack {
    // Labels
    //self.songLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    //self.artistLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    // Artwork
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.songImageView.image = [artwork imageWithSize:self.songImageView.frame.size];
    }
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer volumeChanged:(float)volume {
    //self.volumeSlider.value = volume;
}

- (IBAction)playpauseButton:(id)sender {

    if ([GVMusicPlayerController sharedInstance].playbackState == MPMusicPlaybackStatePlaying) {
        [[GVMusicPlayerController sharedInstance] pause];
        [sender setImage:[UIImage imageNamed:@"Controls_Play.png"] forState:UIControlStateNormal];
        self.songIsPlaying = NO;
    } else {
        [[GVMusicPlayerController sharedInstance] play];
        [sender setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
        self.songIsPlaying = YES;
    }
    
}

- (IBAction)backwardButtonPressed:(id)sender {
    [[GVMusicPlayerController sharedInstance] skipToPreviousItem];
}

- (IBAction)nextButtonPressed:(id)sender {
    [[GVMusicPlayerController sharedInstance] skipToNextItem];
}

- (IBAction)homeButtonTapped:(id)sender {
    
}
- (IBAction)volumeUpTapped:(id)sender {
    
}
- (IBAction)volumeDownTapped:(id)sender {
    
}

@end
