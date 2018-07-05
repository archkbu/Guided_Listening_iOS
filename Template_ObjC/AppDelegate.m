//  Created by Dave Fung.
//  Copyright (c) 2015 Hong Kong Baptist University. All rights reserved.

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[GlobalValues setShowPasswordPageForFirstTimeUsing:YES];
    //[GlobalValues setAppPassword:@"root"];
    [GlobalValues setIsOnDemo:NO];
    //[BookmarksHelper useBookmarks:nil];
    
    UIStoryboard *storyBoard;
    NSString *rootViewName=@"UniversityVC";
    storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController=[storyBoard instantiateViewControllerWithIdentifier:rootViewName];
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:initViewController];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:216.0/255.0 green:139.0/255.0 blue:132.0/255.0 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:139.0/255.0 blue:132.0/255.0 alpha:1]];
    
    [self.window setRootViewController:navController];
    return YES;
}

-(void)setStatusBarBackgroundColor:(UIColor *)color{
    UIView *statusBar=[[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if([statusBar respondsToSelector:@selector(setBackgroundColor:)])statusBar.backgroundColor=color;
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
