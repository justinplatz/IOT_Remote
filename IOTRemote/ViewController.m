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
@property (nonatomic, assign) BOOL lightIsOn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.lightIsOn = NO;
    
    
    self.addBordersToViews;
    self.setAllViewsToGrayBackground;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addBordersToViews{
    self.lightView.layer.borderColor = [UIColor lightYellowColor].CGColor;
    self.lightView.layer.borderWidth = 50.0f;
    
    self.alertView.layer.borderColor = [UIColor darkBlueColor].CGColor;
    self.alertView.layer.borderWidth = 50.0f;
    
    self.tvView.layer.borderColor = [UIColor darkRedColor].CGColor;
    self.tvView.layer.borderWidth = 50.0f;
    
    self.discoView.layer.borderColor = [UIColor lightGreenColor].CGColor;
    self.discoView.layer.borderWidth = 50.0f;

    self.musicView.layer.borderColor = [UIColor lightBlueColor].CGColor;
    self.musicView.layer.borderWidth = 50.0f;

    self.fanView.layer.borderColor = [UIColor lightOrangeColor].CGColor;
    self.fanView.layer.borderWidth = 50.0f;
}

-(void)setAllViewsToGrayBackground{
    self.lightView.backgroundColor = [UIColor offGrayColor];
    self.fanView.backgroundColor = [UIColor offGrayColor];
    self.musicView.backgroundColor = [UIColor offGrayColor];
    self.alertView.backgroundColor = [UIColor offGrayColor];
    self.tvView.backgroundColor = [UIColor offGrayColor];
    self.discoView.backgroundColor = [UIColor offGrayColor];
}
- (IBAction)lightButtonPressed:(id)sender {
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

@end
