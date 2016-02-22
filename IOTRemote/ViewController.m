//
//  ViewController.m
//  IOTRemote
//
//  Created by Justin Platz on 2/21/16.
//  Copyright © 2016 ioJP. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *lightView;
@property (strong, nonatomic) IBOutlet UIButton *lightButton;
@property (nonatomic, assign) BOOL lightIsOn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.lightIsOn = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)lightButtonPressed:(id)sender {
    if (self.lightIsOn) {
        [self.lightButton setImage:[UIImage imageNamed:@"light_off.png"] forState:UIControlStateNormal];
        self.lightIsOn = NO;
    }
    else{
        [self.lightButton setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
        self.lightIsOn = YES;
    }
}

@end
