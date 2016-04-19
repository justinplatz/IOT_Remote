//
//  VideoController.m
//  IOTRemote
//
//  Created by Ryan Stern on 4/12/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "VideoController.h"
#import "UIColor+IOTRemote_Colors.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GoogleCast/GoogleCast.h>

static NSString * kReceiverAppID;

@interface VideoController () <GCKDeviceScannerListener,
GCKDeviceManagerDelegate,
GCKMediaControlChannelDelegate>{
    
    
}

@property GCKMediaControlChannel *mediaControlChannel;
@property GCKApplicationMetadata *applicationMetadata;
@property GCKDevice *selectedDevice;
@property(nonatomic, strong) GCKDeviceScanner *deviceScanner;
@property(nonatomic, strong) GCKDeviceManager *deviceManager;
@property(nonatomic, strong) GCKMediaInformation *mediaInformation;
@property(nonatomic, strong)AVPlayerViewController *localPlayer;
@property BOOL isPlayingLocally;
@property BOOL isPlayingOnChromeCast;
@end



@implementation VideoController


NSArray *vidLinks;
unsigned long vidIndex;
NSURL *currentPlaying;
float GCvol;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBordersToViews];
    self.homeView.layer.borderColor = [UIColor blackColor].CGColor;
    self.homeView.layer.borderWidth = 15.0f;
    _isPlayingOnChromeCast = NO;
    _isPlayingLocally = NO;
    [self loadVideoLinks];
    //unsigned long size = vidLinks.count;
    //NSLog(@"%ld", size);

    
    kReceiverAppID= kGCKMediaDefaultReceiverApplicationID;
    // Establish filter criteria.
    GCKFilterCriteria *filterCriteria = [GCKFilterCriteria
                                         criteriaForAvailableApplicationWithID:kReceiverAppID];
    
    
    // Initialize device scanner.
    self.deviceScanner = [[GCKDeviceScanner alloc] initWithFilterCriteria:filterCriteria];
    [_deviceScanner addListener:self];
    [_deviceScanner startScan];
    [_deviceScanner setPassiveScan:YES];
    GCvol = 0.5;
    
    if(_localPlayer == nil){
        _localPlayer = [[AVPlayerViewController alloc] init];
        vidIndex = 0;
        //[self disablePrevButton];
        currentPlaying = [NSURL URLWithString:vidLinks[0]];
        _localPlayer.player = [AVPlayer playerWithURL:currentPlaying];
    }
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

-(void)loadVideoLinks{
    NSURL *url = [NSURL URLWithString:@"https://dl.dropbox.com/s/57iyh3kvis6u1u9/IOTVideos.txt"];
    NSError* error;
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    NSString *myString = nil;
    NSString * result = @"";
    NSArray* allLinedStrings =
    [content componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    for (NSString* line in allLinedStrings) {
        if (line.length) {
            NSString *str = [line stringByReplacingOccurrencesOfString:@"www"withString:@"dl"];
            str = [str substringToIndex:[str length]-5];
            //NSLog(@"the new line content is: %@", str);
            myString = [NSString stringWithFormat:@"%@\r",str];
            result = [result stringByAppendingString: myString];
        }
    }
    vidLinks = [result componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

-(void)playVideoLocally{
    if(!_isPlayingLocally) _isPlayingLocally = YES;
    _localPlayer.view.frame = CGRectMake(8, 17, 891, 567);
    _localPlayer.showsPlaybackControls = YES;
    _localPlayer.player.volume = 0.5;
    [self addChildViewController:_localPlayer];
    [self.view addSubview:_localPlayer.view];
    [_localPlayer didMoveToParentViewController:self];
    [_localPlayer.player play];
}



//---------------------------------------------BUTTONS--------------------------------------------//
- (IBAction)prevBtn:(UIButton *)sender {
    if(_isPlayingLocally){
        //if(vidIndex == (vidLinks.count - 1)) [self enableNextButton];
        if(_localPlayer.player.rate == 1) [_localPlayer.player pause];
    
        if(vidIndex == 0) vidIndex = vidLinks.count - 2;
        else --vidIndex;
        currentPlaying = [NSURL URLWithString:vidLinks[vidIndex]];
        _localPlayer.player = [AVPlayer playerWithURL:currentPlaying];
        
        [self playVideoLocally];
        [self disableHomeButton];
        [self.playPauseChanger setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
    }
    else if(_isPlayingOnChromeCast){
        if(vidIndex == 0) vidIndex = vidLinks.count - 2;
        else --vidIndex;
        [self castVideo];
    }
}

- (IBAction)playPauseBtn:(UIButton *)sender {
    if((!_isPlayingLocally && !_isPlayingOnChromeCast) || _isPlayingLocally)
    {
        if(!_isPlayingLocally)
        {
            _isPlayingLocally = YES;
            [sender setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
            [self disableHomeButton];
            [self playVideoLocally];
            return;
        }
        else if(_localPlayer.player.rate == 0)
        {
            [_localPlayer.player play];
            [sender setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
            [self disableHomeButton];
        }
        else if(_localPlayer.player.rate == 1)
        {
            [_localPlayer.player pause];
            [sender setImage:[UIImage imageNamed:@"Controls_Play.png"] forState:UIControlStateNormal];
            [self enableHomeButton];
        }
    }
    else{
        if(_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePlaying){
            [_mediaControlChannel pause];
            [sender setImage:[UIImage imageNamed:@"Controls_Play.png"] forState:UIControlStateNormal];
            [self enableHomeButton];
        }
        else if(_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePaused){
            [_mediaControlChannel play];
            [sender setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
            [self disableHomeButton];
        }
        
    }
    
    
}

//CHANGE SO BUTTONS DON'T DISAPPEAR SAME WITH PREV AND HOME
- (IBAction)nextBtn:(UIButton *)sender {
    if((!_isPlayingLocally && !_isPlayingOnChromeCast) || _isPlayingLocally){
        if(_localPlayer.player.rate == 1) [_localPlayer.player pause];
        //if(vidIndex == 0) [self enablePrevButton];
        
        if(vidIndex == (vidLinks.count - 2)) vidIndex = 0;
        else ++vidIndex;
        currentPlaying = [NSURL URLWithString:vidLinks[vidIndex]];
        _localPlayer.player = [AVPlayer playerWithURL:currentPlaying];
        [self playVideoLocally];
        [self disableHomeButton];
        [self.playPauseChanger setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
    }
    else if(_isPlayingOnChromeCast){
        //if(vidIndex == 0) [self enablePrevButton];
        if(vidIndex == (vidLinks.count - 2)) vidIndex = 0;
        else ++vidIndex;
        [self castVideo];
        
    }
}

- (IBAction)homeBtn:(UIButton *)sender {
    [self deviceDisconnected];
}

- (IBAction)castBtn:(UIButton *)sender {
    
    if (_selectedDevice == nil) {
        // [START showing-devices]
        [_deviceScanner setPassiveScan:NO];
        // Choose device.
        
        for (GCKDevice *device in _deviceScanner.devices) {
            if([device.friendlyName  isEqual: @"CHROME"]){
                _selectedDevice = device;
                _isPlayingOnChromeCast = YES;
                [self connectToDevice];
                return;
            }
        }
        if(_selectedDevice == nil){
            NSLog(@"Could Not find device;");
        }
    }
    else{
        [self deviceDisconnected];
    }
}

- (IBAction)volumeUpBtn:(UIButton *)sender {
    if(_isPlayingLocally){
        if(_localPlayer.player.volume < 1)_localPlayer.player.volume += .1;
    }
    else if(_isPlayingOnChromeCast){
        if(_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePlaying ||
           _mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePaused)
        {
            if(GCvol < 1){
                GCvol += .1;
                [_mediaControlChannel setStreamVolume:GCvol];
            }
        }
    }
}

- (IBAction)volumeDownBtn:(UIButton *)sender {
    if(_isPlayingLocally){
        if(_localPlayer.player.volume > 0)_localPlayer.player.volume -= .1;
    }
    else if(_isPlayingOnChromeCast){
        if(_mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePlaying ||
           _mediaControlChannel.mediaStatus.playerState == GCKMediaPlayerStatePaused)
        {
            if(GCvol > 0){
                GCvol -= .1;
                [_mediaControlChannel setStreamVolume:GCvol];
            }
        }
    }
}


-(void)addBordersToViews{
    self.prevView.layer.backgroundColor = [UIColor sunsetOrange].CGColor;
    self.playPauseView.layer.backgroundColor = [UIColor emerald].CGColor;
    self.nextView.layer.backgroundColor = [UIColor babyBlue].CGColor;
    self.homeView.layer.backgroundColor = [UIColor saffronYellow].CGColor;
    self.castView.layer.backgroundColor = [UIColor lightOrangeColor].CGColor;
    self.volumeDownView.layer.backgroundColor = [UIColor babyBlue].CGColor;
    self.volumeUpView.layer.backgroundColor = [UIColor sunsetOrange].CGColor;
    
}

-(void)disablePrevButton{
    self.prevChanger.enabled = NO;
    [self.prevChanger setImage:nil forState:UIControlStateNormal];
    self.prevView.layer.backgroundColor = [UIColor blackColor].CGColor;
}

-(void)enablePrevButton{
    self.prevChanger.enabled = YES;
    [self.prevChanger setImage:[UIImage imageNamed:@"Controls_Back.png"]  forState:UIControlStateNormal];
    self.prevView.layer.backgroundColor = [UIColor sunsetOrange].CGColor;
}

-(void)disableNextButton{
    self.nextChanger.enabled = NO;
    [self.nextChanger setImage:nil forState:UIControlStateNormal];
    self.nextView.layer.backgroundColor = [UIColor blackColor].CGColor;
}

-(void)enableNextButton{
    self.nextChanger.enabled = YES;
    [self.nextChanger setImage:[UIImage imageNamed:@"Controls_Skip.png"]  forState:UIControlStateNormal];
    self.nextView.layer.backgroundColor = [UIColor babyBlue].CGColor;
}

-(void)disableHomeButton{
    self.homeDisabler.enabled = NO;
    [self.homeDisabler setImage:nil forState:UIControlStateNormal];
}

-(void)enableHomeButton{
    self.homeDisabler.enabled = YES;
    [self.homeDisabler setImage:[UIImage imageNamed:@"home.png"]  forState:UIControlStateNormal];
}
//--------------------------------------------CHROMECAST-----------------------------------------------------//

- (void)updateStatsFromDevice {
    
    if (_mediaControlChannel &&
        _deviceManager.connectionState == GCKConnectionStateConnected) {
        _mediaInformation = _mediaControlChannel.mediaStatus.mediaInformation;
    }
}

- (void)connectToDevice {
    if (_selectedDevice == nil) {
        return;
    }
    
    self.deviceManager =
    [[GCKDeviceManager alloc] initWithDevice:_selectedDevice
                           clientPackageName:[NSBundle mainBundle].bundleIdentifier];
    self.deviceManager.delegate = self;
    [_deviceManager connect];
}

- (void)deviceDisconnected {
    self.mediaControlChannel = nil;
    self.deviceManager = nil;
    self.selectedDevice = nil;
}

- (void)updateButtonStates {
    if (_deviceScanner && _deviceScanner.devices.count > 0) {
        // Show the Cast button.
        //self.navigationItem.rightBarButtonItems = @[_googleCastButton];
        if (_deviceManager && _deviceManager.connectionState == GCKConnectionStateConnected) {
            // Show the Cast button in the enabled state.
            //[_googleCastButton setTintColor:[UIColor blueColor]];
        } else {
            // Show the Cast button in the disabled state.
            //[_googleCastButton setTintColor:[UIColor grayColor]];
        }
    } else {
        //Don't show cast button.
        //self.navigationItem.rightBarButtonItems = @[];
    }
}

- (void)castVideo {
    NSLog(@"Cast Video");
    
    // Show alert if not connected.
    if (!_deviceManager
        || _deviceManager.connectionState != GCKConnectionStateConnected) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Not Connected"
                                            message:@"Please connect to Cast device"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // Define media metadata.
    
    // Define Media information.
    // [START load-media]
    GCKMediaInformation *mediaInformation =
    [[GCKMediaInformation alloc] initWithContentID:vidLinks[vidIndex]
                                        streamType:GCKMediaStreamTypeNone
                                       contentType:@"video/mp4"
                                          metadata:nil
                                    streamDuration:0
                                        customData:nil];
    
    // Cast the video.
    
    
    
    if(_isPlayingLocally){
        [_localPlayer.player pause];
        NSTimeInterval startTime = CMTimeGetSeconds(_localPlayer.player.currentItem.currentTime);
        _isPlayingLocally = NO;
        [_localPlayer.view removeFromSuperview];
        [_mediaControlChannel loadMedia:mediaInformation autoplay:YES playPosition:startTime];
    }
    else{
        [_mediaControlChannel loadMedia:mediaInformation autoplay:YES playPosition:0];
    }
    // [END load-media]
    
}

#pragma mark - GCKDeviceScannerListener
- (void)deviceDidComeOnline:(GCKDevice *)device {
    NSLog(@"device found!! %@", device.friendlyName);
    [self updateButtonStates];
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
    [self updateButtonStates];
}
#pragma mark - GCKDeviceManagerDelegate

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
    NSLog(@"connected to %@!", _selectedDevice.friendlyName);
    
    [self updateButtonStates];
    [_deviceManager launchApplication:kReceiverAppID];
}

// [START media-control-channel]
- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApplication {
    
    NSLog(@"application has launched");
    self.mediaControlChannel = [[GCKMediaControlChannel alloc] init];
    self.mediaControlChannel.delegate = self;
    [_deviceManager addChannel:self.mediaControlChannel];
    // [START_EXCLUDE silent]
    [_mediaControlChannel requestStatus];
    [self castVideo];
    [self.playPauseChanger setImage:[UIImage imageNamed:@"Controls_Pause.png"] forState:UIControlStateNormal];
    //[END_EXCLUDE silent]
}
// [END media-control-channel]

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectToApplicationWithError:(NSError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didFailToConnectWithError:(GCKError *)error {
    [self showError:error];
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(GCKError *)error {
    NSLog(@"Received notification that device disconnected");
    if (error != nil) {
        [self showError:error];
    }
    
    [self deviceDisconnected];
    [self updateButtonStates];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didReceiveStatusForApplication:(GCKApplicationMetadata *)applicationMetadata {
    self.applicationMetadata = applicationMetadata;
}

#pragma mark - misc
- (void)showError:(NSError *)error {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Error"
                                        message:error.description
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

