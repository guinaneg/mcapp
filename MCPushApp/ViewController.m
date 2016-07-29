//
//  ViewController.m
//  MCPushApp
//
//  Created by Gavin Guinane on 7/29/16.
//  Copyright © 2016 Gavin Guinane. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //// Do any additional setup after loading the view, typically from a nib.
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    //label.text = @"Hello again!";
    //[self.view addSubview:label];
    
    self.HelloLabel.text = @"Subscriber ID";
    [self.Connect setTitle:@"Send to Marketing Cloud" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleButtonClick:(id)sender {
    self.SubscriberId.text = @"HolyMoly";
}

@end
