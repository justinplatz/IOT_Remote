//
//  UIViewController+AlertViewController.m
//  IOTRemote
//
//  Created by Justin Platz on 4/9/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "AlertViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIColor+IOTRemote_Colors.h"

@interface AlertViewController ()
@property (strong, nonatomic) IBOutlet UIView *helpView;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;
@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (strong, nonatomic) IBOutlet UIView *homeButton;
@property (strong, nonatomic) IBOutlet UIView *foodView;
@property (strong, nonatomic) IBOutlet UIButton *foodButton;
@property (strong, nonatomic) IBOutlet UIView *bathroomView;
@property (strong, nonatomic) IBOutlet UIButton *bathroomButton;
@property (strong, nonatomic) IBOutlet UIView *playView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIView *hiView;
@property (strong, nonatomic) IBOutlet UIButton *hiButton;

@end

@implementation AlertViewController: UIViewController

- (void)viewDidLoad
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)sendMessage:(NSString*)message{
    NSString *kTwilioSID = @"AC8c0a5caf4665a25c6d0fd0a63a7ea505";
    NSString *kTwilioSecret = @"3eafdb27571da26adcac96e2a35ec961";
    NSString *kFromNumber = @"+15165003260";
    NSString *kToNumber = @"+15164763716";//replace you number here
    
    NSString *urlString = [NSString
                           stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages/",
                           kTwilioSID, kTwilioSecret,kTwilioSID];
    
    NSDictionary* dic=@{@"From":kFromNumber,@"To":kToNumber,@"Body":message};
    
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
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@, %@", error, operation.responseObject);
     }];
    
}

- (IBAction)playButtonPressed:(id)sender {
    [self sendMessage:@"I'm bored. Lets play!"];
    [self playClickSound];
}
- (IBAction)foodButtonPressed:(id)sender {
    [self sendMessage:@"I'm hungry. Lets eat!"];
    [self playClickSound];
}
- (IBAction)helpButtonPressed:(id)sender {
    [self sendMessage:@"I need some help. Please come!"];
    [self playClickSound];
}
- (IBAction)bathroomButtonPressed:(id)sender {
    [self sendMessage:@"I need to use the bathroom. Please come!"];
    [self playClickSound];
}

-(void)playClickSound{
    NSString *soundTitle = @"click_sound";
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundTitle ofType:@"mp3"];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((CFURLRef)CFBridgingRetain(soundUrl), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end