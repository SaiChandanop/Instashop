//
//  AppDelegate.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AppDelegate.h"
#import "InstagramUserObject.h"
#import "ZenCartAuthenticationAPIHandler.h"
#import "AttributesManager.h"
#import "SellersAPIHandler.h"

#define INSTAGRAM_CLIENT_ID @"d63f114e63814512b820b717a73e3ada"
#define INSTAGRAM_CLIENT_SECRET @"75cd3c5f8d894ed7a826c4af7f1f085f"
//WEBSITE URL	http://instashop.com
//REDIRECT URI	igd63f114e63814512b820b717a73e3ada://authorize



@implementation AppDelegate

@synthesize instagram, authenticationViewController, appRootViewController;
@synthesize pushDeviceTokenString;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

//    [ZenCartAuthenticationAPIHandler makeLoginRequest];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    self.instagram = [[Instagram alloc] initWithClientId:INSTAGRAM_CLIENT_ID delegate:nil];
    self.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    self.authenticationViewController = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationViewController" bundle:nil];
    self.appRootViewController = [[AppRootViewController alloc] initWithNibName:nil bundle:nil];
    
    
    if ([self.instagram isSessionValid] && [InstagramUserObject getStoredUserObject])
        self.window.rootViewController = self.appRootViewController;
    else
        self.window.rootViewController = self.authenticationViewController;
    
    
    [self.window makeKeyAndVisible];
    
   [[UIBarButtonItem appearance]
     setBackButtonBackgroundImage:[UIImage imageNamed:@"backbutton.png"]
     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
 
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	const unsigned* tokenBytes = [deviceToken bytes];
    self.pushDeviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                   ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                   ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
	NSLog(@"%@", self.pushDeviceTokenString);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0)
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

-(void)userDidLogin
{
    self.window.rootViewController = self.appRootViewController;
}

-(void)makeSafariCallWithURL:(NSURL *)theURL
{
    NSLog(@"makeSafariCallWithURL: %@", theURL);
    [self.authenticationViewController makeLoginRequestWithURL:theURL];
}

// YOU NEED TO CAPTURE igAPPID:// schema
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSLog(@"application: %@, handleOpenURL: %@", application, url);
    
    return [self.instagram handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"application: %@, handleOpenURL: %@, sourceApplication %@, annotation: %@", application, url, sourceApplication, annotation);
    return [self.instagram handleOpenURL:url];
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
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

- (void)dealloc
{
    [_window release];
    [super dealloc];
}




/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
