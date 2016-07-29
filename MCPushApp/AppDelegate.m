//
//  AppDelegate.m
//  MCPushApp
//
//  Created by Gavin Guinane on 7/29/16.
//  Copyright © 2016 Gavin Guinane. All rights reserved.
//

#import "AppDelegate.h"
#import "ETPush.h"

@interface AppDelegate ()

@end

static NSString *kETAppID_Debug       = @"a2eaa6fe-9a01-4427-9753-1695768358ca"; // uses Sandbox APNS for debug builds
static NSString *kETAccessToken_Debug = @"mh7unqtsg6vkb9wydtcdd94b";
static NSString *kETAppID_Prod        = @"a2eaa6fe-9a01-4427-9753-1695768358ca";       // uses Production APNS
static NSString *kETAccessToken_Prod  = @"mh7unqtsg6vkb9wydtcdd94b";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BOOL successful = NO;
    NSError *error = nil;

    #ifdef DEBUG
        // Set to YES to enable logging while debugging
        [ETPush setETLoggerToRequiredState:YES];
    
        // configure and set initial settings of the JB4ASDK
        successful = [[ETPush pushManager] configureSDKWithAppID:kETAppID_Debug
                                              andAccessToken:kETAccessToken_Debug
                                               withAnalytics:YES
                                         andLocationServices:YES       // ONLY SET TO YES IF PURCHASED AND USING GEOFENCE CAPABILITIES
                                        andProximityServices:NO       // ONLY SET TO YES IF YOU ARE PART OF THE BEACON BETA PROGRAM
                                               andCloudPages:NO       // ONLY SET TO YES IF PURCHASED AND USING CLOUDPAGES
                                             withPIAnalytics:YES
                                                       error:&error];
    #else
        // configure and set initial settings of the JB4ASDK
        successful = [[ETPush pushManager] configureSDKWithAppID:kETAppID_Prod
                                              andAccessToken:kETAccessToken_Prod
                                               withAnalytics:YES
                                         andLocationServices:YES       // ONLY SET TO YES IF PURCHASED AND USING GEOFENCE CAPABILITIES
                                        andProximityServices:YES       // ONLY SET TO YES IF YOU ARE PART OF THE BEACON BETA PROGRAM
                                               andCloudPages:YES       // ONLY SET TO YES IF PURCHASED AND USING CLOUDPAGES
                                             withPIAnalytics:YES
                                                       error:&error];
    
    #endif
    
    [ETPush setETLoggerToRequiredState:YES];
 
    if (!successful) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // something failed in the configureSDKWithAppID call - show what the error is
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed configureSDKWithAppID!", @"Failed configureSDKWithAppID!")
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                              otherButtonTitles:nil] show];
        });
    }
    else {
        // register for push notifications - enable all notification types, no categories
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound |
                                                UIUserNotificationTypeAlert
                                                                                 categories:nil];
        
        [[ETPush pushManager] registerUserNotificationSettings:settings];
        [[ETPush pushManager] registerForRemoteNotifications];
        
        // inform the JB4ASDK of the launch options
        // possibly UIApplicationLaunchOptionsRemoteNotificationKey or UIApplicationLaunchOptionsLocalNotificationKey
        [[ETPush pushManager] applicationLaunchedWithOptions:launchOptions];
        
        // This method is required in order for location messaging to work and the user's location to be processed
        // Only call this method if you have LocationServices set to YES in configureSDK()
        [[ETLocationManager sharedInstance] startWatchingLocation];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // inform the JB4ASDK of the notification settings requested
    [[ETPush pushManager] didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // inform the JB4ASDK of the device token
    [[ETPush pushManager] registerDeviceToken:deviceToken];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // inform the JB4ASDK that the device failed to register and did not receive a device token
    [[ETPush pushManager] applicationDidFailToRegisterForRemoteNotificationsWithError:error];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // inform the JB4ASDK that the device received a local notification
    [[ETPush pushManager] handleLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    
    // inform the JB4ASDK that the device received a remote notification
    [[ETPush pushManager] handleNotification:userInfo forApplicationState:application.applicationState];
    
    // is it a silent push?
    if (userInfo[@"aps"][@"content-available"]) {
        // received a silent remote notification...
        
        // indicate a silent push
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
    else {
        // received a remote notification...
        
        // clear the badge
        [[ETPush pushManager] resetBadgeCount];
    }
    
    handler(UIBackgroundFetchResultNoData);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
