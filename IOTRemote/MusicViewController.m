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
#import <AVFoundation/AVFoundation.h>
#import "NSString+TimeToString.h"

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
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;

@property (strong, nonatomic) IBOutlet UILabel *trackCurrentPlaybackTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackLengthLabel;
@property (strong, nonatomic) IBOutlet UISlider *progressSlider;

@property (nonatomic, assign) MPMediaItem *nowPlayingSong;
@property BOOL panningProgress;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MusicViewController : UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBordersToViews];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timedJob) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GVMusicPlayerController sharedInstance] addDelegate:self];
    [GVMusicPlayerController sharedInstance].repeatMode = MPMusicRepeatModeAll;
    
    self.nowPlayingSong = [[GVMusicPlayerController sharedInstance] nowPlayingItem];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[GVMusicPlayerController sharedInstance] removeDelegate:self];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    [[GVMusicPlayerController sharedInstance] remoteControlReceivedWithEvent:receivedEvent];
}

-(void)addBordersToViews{
    self.backwardView.layer.backgroundColor = [UIColor lightYellowColor].CGColor;
    
    self.playpauseView.layer.backgroundColor = [UIColor darkBlueColor].CGColor;
    
    self.nextView.layer.backgroundColor = [UIColor darkRedColor].CGColor;
    
    self.posistionView.layer.backgroundColor = [UIColor lightGreenColor].CGColor;
    
    self.songInfoView.layer.backgroundColor = [UIColor lightGreenColor].CGColor;
    
    self.songArtView.layer.backgroundColor = [UIColor lightBlueColor].CGColor;
    
    self.homeView.layer.backgroundColor = [UIColor lightYellowColor].CGColor;
    
    self.volumeUpView.layer.backgroundColor = [UIColor darkBlueColor].CGColor;
    
    self.volumeDownView.layer.backgroundColor = [UIColor darkRedColor].CGColor;
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState {
    self.playPauseButton.selected = (playbackState == MPMusicPlaybackStatePlaying);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack {
    
    // Time labels
    NSTimeInterval trackLength = [[nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    self.trackLengthLabel.text = [NSString stringFromTime:trackLength];
    self.progressSlider.value = 0;
    self.progressSlider.maximumValue = trackLength;
    
    // Song Labels
    self.songLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    self.artistLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    // Artwork
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.songImageView.image = [artwork imageWithSize:self.songArtView.frame.size];
    }
    
    
    if ([GVMusicPlayerController sharedInstance].playbackState != MPMusicPlaybackStatePlaying) {
        [self.playPauseButton setImage:[UIImage imageNamed:@"Controls_Play.png"] forState:UIControlStateNormal];
    } else {
        [self.playPauseButton setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
    }
    
    self.nowPlayingSong = nowPlayingItem;
}

- (IBAction)playpauseButton:(id)sender {
    if ([GVMusicPlayerController sharedInstance].playbackState == MPMusicPlaybackStatePlaying) {
        [[GVMusicPlayerController sharedInstance] pause];
        [sender setImage:[UIImage imageNamed:@"Controls_Play.png"] forState:UIControlStateNormal];
    } else {
        [[GVMusicPlayerController sharedInstance] play];
        [sender setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
    }

    if (self.nowPlayingSong == nil) {
        [GVMusicPlayerController sharedInstance].shuffleMode = MPMusicShuffleModeSongs;
        #if !(TARGET_IPHONE_SIMULATOR)
        MPMediaQuery *query = [MPMediaQuery songsQuery];
        [[GVMusicPlayerController sharedInstance] setQueueWithQuery:query];
        [[GVMusicPlayerController sharedInstance] play];
        #endif
        [self.playPauseButton setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
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
    float vol = [[AVAudioSession sharedInstance] outputVolume];
    [[GVMusicPlayerController sharedInstance] setVolume:vol+.05];

}
- (IBAction)volumeDownTapped:(id)sender {
    float vol = [[AVAudioSession sharedInstance] outputVolume];
    [[GVMusicPlayerController sharedInstance] setVolume:vol-.05];
}

- (void)timedJob {
    if (!self.panningProgress) {
        self.progressSlider.value = [GVMusicPlayerController sharedInstance].currentPlaybackTime;
        self.trackCurrentPlaybackTimeLabel.text = [NSString stringFromTime:[GVMusicPlayerController sharedInstance].currentPlaybackTime];
    }
}

- (IBAction)progressChanged:(UISlider *)sender {
    // While dragging the progress slider around, we change the time label,
    // but we're not actually changing the playback time yet.
    self.panningProgress = YES;
    self.trackCurrentPlaybackTimeLabel.text = [NSString stringFromTime:sender.value];
}

- (IBAction)progressEnd {
    // Only when dragging is done, we change the playback time.
    [GVMusicPlayerController sharedInstance].currentPlaybackTime = self.progressSlider.value;
    self.panningProgress = NO;
}

@end
