//
//  AppDelegate.m
//  arm
//
//  Created by Owner on 2013/12/17.
//  Copyright (c) 2013年 jssa. All rights reserved.
//

#import "AppDelegate.h"
#import <Dropbox/Dropbox.h>
#import "NotesFolderListController.h"

#define DROPBOX_APP_KEY @"d73c8bmty7abx4r"
#define DROPBOX_APP_SECRET @"1qkobii8xezyjtt"
@implementation AppDelegate

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Dropbox接続に必要な情報をセット
    DBAccountManager* accountManager =
    [[DBAccountManager alloc] initWithAppKey:DROPBOX_APP_KEY
                                      secret:DROPBOX_APP_SECRET];
    [DBAccountManager setSharedManager:accountManager];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
//        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
//        NotesFolderListController *folderController =
//        [[NotesFolderListController alloc] initWithFilesystem:filesystem root:[DBPath root]];
//        [self.rootController pushViewController:folderController animated:YES];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
