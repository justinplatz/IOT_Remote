//
//  ViewController.m
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "ViewController.h"
#import "YO/YO.h"
#import "UIColor+IOTRemote_Colors.h"
#import <PubNub/PubNub.h>
#import "AFHTTPRequestOperationManager.h"

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
    [self addBordersToViews];
    [self setAllViewsToGrayBackground];
    
    NSString *Switch1 = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Switch1"];
    if ([Switch1 containsString:@"On"]) {
        [self turnLightButtonOn];
    }
    else{
        [self turnLightButtonOff];
    }
    
    NSString *Switch2 = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"Switch2"];
    if ([Switch2 containsString:@"On"]) {
        [self turnFanButtonOn];
    }
    else{
        [self turnFanButtonOff];
    }

    NSString *Switch3 = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"Switch3"];
    if ([Switch3 containsString:@"On"]) {
        [self turnDiscoButtonOn];
    }
    else{
        [self turnDiscoButtonOff];
    }
    
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
    self.lightView.layer.borderColor = [UIColor saffronYellow].CGColor;
    self.lightView.layer.borderWidth = 30.0f;
    
    self.alertView.layer.borderColor = [UIColor pictonBlue].CGColor;
    self.alertView.layer.borderWidth = 30.0f;
    
    self.tvView.layer.borderColor = [UIColor sunsetOrange].CGColor;
    self.tvView.layer.borderWidth = 30.0f;
    
    self.discoView.layer.borderColor = [UIColor californiaYellow].CGColor;
    self.discoView.layer.borderWidth = 30.0f;

    self.musicView.layer.borderColor = [UIColor mediumPurple].CGColor;
    self.musicView.layer.borderWidth = 30.0f;

    self.fanView.layer.borderColor = [UIColor shamrockGreen].CGColor;
    self.fanView.layer.borderWidth = 30.0f;
}

-(void)setAllViewsToGrayBackground{
    self.lightView.backgroundColor = [UIColor offGrayColor];
    self.fanView.backgroundColor   = [UIColor offGrayColor];
    self.musicView.backgroundColor = [UIColor mediumPurple];
    self.alertView.backgroundColor = [UIColor pictonBlue];
    self.tvView.backgroundColor    = [UIColor sunsetOrange];
    self.discoView.backgroundColor = [UIColor offGrayColor];
}

-(void) turnLightButtonOff{
    [self.lightButton setImage:[UIImage imageNamed:@"light_off.png"] forState:UIControlStateNormal];
    self.lightIsOn = NO;
    self.lightView.backgroundColor = [UIColor offGrayColor];
}

-(void) turnLightButtonOn{
    [self.lightButton setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
    self.lightIsOn = YES;
    self.lightView.backgroundColor = [UIColor saffronYellow];
}

- (IBAction)lightButtonPressed:(id)sender {
    [self playClickSound];
    
    if (self.lightIsOn) {
        [self sendMessageToTwilio:@"#Switch1Off"];
    }
    else{
        [self sendMessageToTwilio:@"#Switch1On"];
    }
}

- (IBAction)alertButtonPressed:(id)sender {
    [self playClickSound];
}

//7jcbovka54f6o
- (void)sendMessageToTwilio: (NSString*) message{
    NSString *kTwilioSID = @"AC8c0a5caf4665a25c6d0fd0a63a7ea505";
    NSString *kTwilioSecret = @"3eafdb27571da26adcac96e2a35ec961";
    NSString *kFromNumber = @"+15165003260";
    NSString *kToNumber = @"+14156826723";//replace you number here
    NSString *kMessage = message;
    
    NSString *urlString = [NSString
                           stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages/",
                           kTwilioSID, kTwilioSecret,kTwilioSID];
    
    NSDictionary* dic=@{@"From":kFromNumber,@"To":kToNumber,@"Body":kMessage};
    
    __block NSArray* jsonArray;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/xml"];
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError* err;
         NSLog(@"success %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         jsonArray=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments
                                                     error:&err];
         NSLog(@"JSON: %@", jsonArray);
         [self showSuccessImage];
         if ([message containsString:@"1"]) {
             [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"Switch1"];
             if ([message containsString:@"On"]) {
                 [self turnLightButtonOn];
             }
             else{
                 [self turnLightButtonOff];
             }
         }
         else if ([message containsString:@"2"]) {
             [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"Switch2"];
             if ([message containsString:@"On"]) {
                 [self turnFanButtonOn];
             }
             else{
                 [self turnFanButtonOff];
             }
         }
         else if ([message containsString:@"3"]) {
             [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"Switch3"];
             if ([message containsString:@"On"]) {
                 [self turnDiscoButtonOn];
             }
             else{
                 [self turnDiscoButtonOff];
             }
         }
         else{
             //ERROR I DONT RECOGNIZE THIS SWITCH!!!!
         }
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@, %@", error, jsonArray);
         [self showErrorImage];
     }];
    
}

-(void) turnFanButtonOn{
    [self.fanButton setImage:[UIImage imageNamed:@"fan_on.png"] forState:UIControlStateNormal];
    self.fanIsOn = YES;
    self.fanView.backgroundColor = [UIColor shamrockGreen];
}

-(void) turnFanButtonOff{
    [self.fanButton setImage:[UIImage imageNamed:@"fan_off.png"] forState:UIControlStateNormal];
    self.fanIsOn = NO;
    self.fanView.backgroundColor = [UIColor offGrayColor];
}

- (IBAction)fanButtonPressed:(id)sender {
    [self playClickSound];
    if (self.fanIsOn) {
        [self sendMessageToTwilio:@"#Switch2Off"];
    }
    else{
        [self sendMessageToTwilio:@"#Switch2On"];
    }
}

- (IBAction)tvButtonPressed:(id)sender {
    
}

- (IBAction)musicButtonPressed:(id)sender {
    
}

-(void) turnDiscoButtonOn{
    [self.discoButton setImage:[UIImage imageNamed:@"disco_on.png"] forState:UIControlStateNormal];
    self.discoIsOn = YES;
    self.discoView.backgroundColor = [UIColor californiaYellow];
}

-(void) turnDiscoButtonOff{
    [self.discoButton setImage:[UIImage imageNamed:@"disco_off.png"] forState:UIControlStateNormal];
    self.discoIsOn = NO;
    self.discoView.backgroundColor = [UIColor offGrayColor];
}

- (IBAction)discoButtonPressed:(id)sender {
    [self playClickSound];
    if (self.discoIsOn) {
        [self sendMessageToTwilio:@"#Switch3Off"];
    }
    else{
        [self sendMessageToTwilio:@"#Switch3On"];
    }
}

-(void)showErrorImage{
    UIImageView *overlayView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    overlayView.image = [UIImage imageNamed:@"messageFail.png"];
    overlayView.backgroundColor = [UIColor whiteSmoke];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.5;
    transition.type = kCATransitionPush; //choose your animation
    [overlayView.layer addAnimation:transition forKey:nil];
    
    [self.view.window addSubview:overlayView];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [overlayView removeFromSuperview];
    });
}

-(void)showSuccessImage{
    UIImageView *overlayView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    overlayView.image = [UIImage imageNamed:@"messageSent.png"];
    overlayView.backgroundColor = [UIColor whiteSmoke];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.5;
    transition.type = kCATransitionPush; //choose your animation
    [overlayView.layer addAnimation:transition forKey:nil];
    
    [self.view.window addSubview:overlayView];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *   NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [overlayView removeFromSuperview];
    });
}

@end
