//
//  ViewController.m
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+IOTRemote_Colors.h"
#import <PubNub/PubNub.h>

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
@property (nonatomic, assign) NSTimer* timer;
@property(nonatomic) CFTimeInterval minimumPressDuration;


@end

@implementation ViewController : UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lightIsOn = NO;
    self.fanButton = NO;
    self.discoIsOn = NO;
    
    
    [self addBordersToViews];
    [self setAllViewsToGrayBackground];
    
    
    // Override point for customization after application launch.
    PNConfiguration *configuration = [
                                      PNConfiguration configurationWithPublishKey:@"pub-c-f83b8b34-5dbc-4502-ac34-5073f2382d96"
                                      subscribeKey:@"sub-c-34be47b2-f776-11e4-b559-0619f8945a4f"];
    
    self.client = [PubNub clientWithConfiguration:configuration];
    [self.client addListener:self];
    
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
    [self playClickSound];
    [self.client publish:@"Test" toChannel: @"light_channel" storeInHistory:YES
          withCompletion:nil];
    
    
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
    [self.alertButton setImage:[UIImage imageNamed:@"alert_on.png"] forState:UIControlStateNormal];

    self.alertView.backgroundColor = [UIColor darkBlueColor];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.alertButton.enabled = YES;
        self.alertView.backgroundColor = [UIColor offGrayColor];
        [self.alertButton setImage:[UIImage imageNamed:@"alert_off.png"] forState:UIControlStateNormal];

    });
}

- (IBAction)alertButtonPressed:(id)sender {
   // self.playClickSound;
    //self.disableButtonTemporarily;
}

- (void)viewWillAppear:(BOOL)animated
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidLongPress:)];
    longPress.minimumPressDuration = 2.0;//this is the pressDuration
    
    [self.alertButton addGestureRecognizer:longPress];
}

- (void)buttonDidLongPress:(UILongPressGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(alertButtonPressed:) userInfo:nil repeats:YES];
            
            NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
            [theRunLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
            [self playClickSound];
            [self disableButtonTemporarily];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.timer invalidate];
            self.timer = nil;
            
        }
            break;
        default:
            break;
    }
}


- (IBAction)fanButtonPressed:(id)sender {
    [self playClickSound];
    if (self.fanIsOn) {
        [self.fanButton setImage:[UIImage imageNamed:@"fan_off.png"] forState:UIControlStateNormal];
        self.fanIsOn = NO;
        self.fanView.backgroundColor = [UIColor offGrayColor];
    }
    else{
        [self.fanButton setImage:[UIImage imageNamed:@"fan_on.png"] forState:UIControlStateNormal];
        self.fanIsOn = YES;
        self.fanView.backgroundColor = [UIColor lightOrangeColor];
    }
}

- (IBAction)tvButtonPressed:(id)sender {
    
}

- (IBAction)musicButtonPressed:(id)sender {
    
}

- (IBAction)discoButtonPressed:(id)sender {
    [self playClickSound];
    if (self.discoIsOn) {
        [self.discoButton setImage:[UIImage imageNamed:@"disco_off.png"] forState:UIControlStateNormal];
        self.discoIsOn = NO;
        self.discoView.backgroundColor = [UIColor offGrayColor];
    }
    else{
        [self.discoButton setImage:[UIImage imageNamed:@"disco_on.png"] forState:UIControlStateNormal];
        self.discoIsOn = YES;
        self.discoView.backgroundColor = [UIColor lightGreenColor];
    }
}


@end
