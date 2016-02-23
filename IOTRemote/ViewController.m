//
//  ViewController.m
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+IOTRemote_Colors.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *lightView;
@property (strong, nonatomic) IBOutlet UIView *fanView;
@property (strong, nonatomic) IBOutlet UIView *musicView;
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UIView *tvView;
@property (strong, nonatomic) IBOutlet UIView *discoView;

@property (strong, nonatomic) IBOutlet UIButton *lightButton;
@property (strong, nonatomic) IBOutlet UIButton *alertButton;
@property (strong, nonatomic) IBOutlet UIButton *fanButton;
@property (strong, nonatomic) IBOutlet UIButton *tvButton;
@property (strong, nonatomic) IBOutlet UIButton *musicButton;
@property (strong, nonatomic) IBOutlet UIButton *discoButton;

@property (nonatomic, assign) BOOL lightIsOn;
@property (nonatomic, assign) BOOL fanIsOn;
@property (nonatomic, assign) BOOL discoIsOn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.lightIsOn = NO;
    self.fanButton = NO;
    self.discoIsOn = NO;
    
    self.addBordersToViews;
    self.setAllViewsToGrayBackground;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)playClickSound{
    NSString *soundTitle = @"click_sound";
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((CFURLRef)CFBridgingRetain(soundUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);
}
-(void)addBordersToViews{
    self.lightView.layer.borderColor = [UIColor lightYellowColor].CGColor;
    self.lightView.layer.borderWidth = 30.0f;
    
    self.alertView.layer.borderColor = [UIColor darkBlueColor].CGColor;
    self.alertView.layer.borderWidth = 30.0f;
    
    self.tvView.layer.borderColor = [UIColor darkRedColor].CGColor;
    self.tvView.layer.borderWidth = 30.0f;
    
    self.discoView.layer.borderColor = [UIColor lightGreenColor].CGColor;
    self.discoView.layer.borderWidth = 30.0f;

    self.musicView.layer.borderColor = [UIColor lightBlueColor].CGColor;
    self.musicView.layer.borderWidth = 30.0f;

    self.fanView.layer.borderColor = [UIColor lightOrangeColor].CGColor;
    self.fanView.layer.borderWidth = 30.0f;
}

-(void)setAllViewsToGrayBackground{
    self.lightView.backgroundColor = [UIColor offGrayColor];
    self.fanView.backgroundColor   = [UIColor offGrayColor];
    self.musicView.backgroundColor = [UIColor offGrayColor];
    self.alertView.backgroundColor = [UIColor offGrayColor];
    self.tvView.backgroundColor    = [UIColor offGrayColor];
    self.discoView.backgroundColor = [UIColor offGrayColor];
}
- (IBAction)lightButtonPressed:(id)sender {
    self.playClickSound;
    if (self.lightIsOn) {
        [self.lightButton setImage:[UIImage imageNamed:@"light_off.png"] forState:UIControlStateNormal];
        self.lightIsOn = NO;
        self.lightView.backgroundColor = [UIColor offGrayColor];
    }
    else{
        [self.lightButton setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
        self.lightIsOn = YES;
        self.lightView.backgroundColor = [UIColor lightYellowColor];
    }
}
-(void)disableButtonTemporarily{
    self.alertButton.enabled = NO;
    self.alertView.backgroundColor = [UIColor darkBlueColor];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.alertButton.enabled = YES;
        self.alertView.backgroundColor = [UIColor offGrayColor];
    });
}

- (IBAction)alertButtonPressed:(id)sender {
    self.playClickSound;
    self.disableButtonTemporarily;
}

- (IBAction)fanButtonPressed:(id)sender {
    self.playClickSound;
    if (self.fanIsOn) {
        self.fanIsOn = NO;
        self.fanView.backgroundColor = [UIColor offGrayColor];
    }
    else{
        self.fanIsOn = YES;
        self.fanView.backgroundColor = [UIColor lightOrangeColor];
    }
}



@end
