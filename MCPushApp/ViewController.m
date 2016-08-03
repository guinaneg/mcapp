//
//  ViewController.m
//  MCPushApp
//
//  Created by Gavin Guinane on 7/29/16.
//  Copyright © 2016 Gavin Guinane. All rights reserved.
//

#import "ViewController.h"
#import "ETPush.h"
#import "ETAnalytics.h"
#import "PICartItem.h"
#import "PICart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    self.HelloLabel.text = @"Subscriber ID";
    [self.Connect setTitle:@"Send to Marketing Cloud" forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleButtonClick:(id)sender {
    //self.SubscriberId.text = @"";
    // Set a subscriber key - will return a true or false value indicating success of call
    bool success = [[ETPush pushManager] setSubscriberKey:self.SubscriberId.text];
    //txtTags
    
    if (!success)
    {
        // handle if subscriberKey is null or blank.
    }
    NSLog(@"The subscriber key is : %@", [[ETPush pushManager] getSubscriberKey]);
    
    success = [[ETPush pushManager] addTag:self.txtTags.text];
    
    success = [[ETPush pushManager] addAttributeNamed:@"City" value:self.txtTags.text];
    success = [[ETPush pushManager] addAttributeNamed:@"FavouriteTeam" value:@"Leeds Utd."];
    
    if (!success)
    {
        // handle if name is null, blank or one of the reserved words.  Or value is null.
        NSLog(@"Failed to add the attribute");

    } else {
        NSLog(@"Attribute added succesfully: %@", self.txtTags.text);
    }
    
    [ETAnalytics trackPageView:@"data://SubscriberKeySet" andTitle:@"User Set Subscriber key" andItem:nil andSearch:nil];
    NSLog(@"Logged to analytics succesfully: %@", @"User Set Subscriber key");
    // track cart contents in the analytics engine
    
    PICartItem *cartItem1 = [[PICartItem alloc] initWithPrice:@(1.10) quantity:@(1) item:@"123456"];
    PICartItem *cartItem2 = [[PICartItem alloc] initWithPrice:@(4.99) quantity:@(3) item:@"2468"];
    PICart *cart = [[PICart alloc] initWithCartItems:@[cartItem1, cartItem2]];
    [ETAnalytics trackCartContents:cart];
}

@end
