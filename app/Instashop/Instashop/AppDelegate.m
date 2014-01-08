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
#import "UserAPIHandler.h"
#import "CategoriesAPIHandler.h"
#import "ProfileViewController.h"

#define INSTAGRAM_CLIENT_ID @"d63f114e63814512b820b717a73e3ada"
#define INSTAGRAM_CLIENT_SECRET @"75cd3c5f8d894ed7a826c4af7f1f085f"
//WEBSITE URL	http://instashop.com
//REDIRECT URI	igd63f114e63814512b820b717a73e3ada://authorize



@implementation AppDelegate

@synthesize instagram, authenticationViewController, appRootViewController;
@synthesize pushDeviceTokenString, instagramShareViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    [ZenCartAuthenticationAPIHandler makeLoginRequest];
    self.instagram = [[Instagram alloc] initWithClientId:INSTAGRAM_CLIENT_ID delegate:nil];
    self.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
//    [self.instagram authorize:[NSArray arrayWithObjects:@"relationships", @"comments", @"likes", nil]];
    
    self.authenticationViewController = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationViewController" bundle:nil];
    self.appRootViewController = [[AppRootViewController alloc] initWithNibName:nil bundle:nil];
    
    if ([self.instagram isSessionValid] && [InstagramUserObject getStoredUserObject])
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        self.window.rootViewController = self.appRootViewController;

    }
    else {
        self.window.rootViewController = self.authenticationViewController;
    }
    
    
    [self.window makeKeyAndVisible];
   
    [CategoriesAPIHandler makeCategoriesRequest];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	const unsigned* tokenBytes = [deviceToken bytes];
    self.pushDeviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                                   ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                                   ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                                   ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];

	NSLog(@"remote notification occured, push string: %@, instagram user id: %@", self.pushDeviceTokenString, [InstagramUserObject getStoredUserObject].userID);
    if ([InstagramUserObject getStoredUserObject].userID != nil)
    {
        [UserAPIHandler updateUserPushIdentityWithPushID:self.pushDeviceTokenString withInstagramID:[InstagramUserObject getStoredUserObject].userID];
        [SellersAPIHandler updateSellerPushIDWithPushID:self.pushDeviceTokenString withInstagramID:[InstagramUserObject getStoredUserObject].userID];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0)
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

-(void)userDidLogin
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    self.window.rootViewController = self.appRootViewController;
}

-(void)userDidLogout
{
    self.authenticationViewController = [[AuthenticationViewController alloc] initWithNibName:@"AuthenticationViewController" bundle:nil];
    
    self.window.rootViewController = self.authenticationViewController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userString = [InstagramUserObject getStoredUserObject].userID;
    NSString *defaultFirstUserKey = [userString stringByAppendingString:@"firstRun"];
    NSArray *keys = [[defaults dictionaryRepresentation] allKeys];
    for (int i = 0; i < [keys count]; i++) {
       // if (![[keys objectAtIndex:i] isEqualToString:defaultFirstUserKey])
            [defaults removeObjectForKey:[keys objectAtIndex:i]];
    }
}

-(void)makeSafariCallWithURL:(NSURL *)theURL
{
    NSLog(@"makeSafariCallWithURL: %@", theURL);
    NSString *urlString = theURL.absoluteString;
    urlString = [urlString stringByReplacingOccurrencesOfString:@"scope=" withString:@"scope=relationships+"];
    NSLog(@"new urlString: %@", urlString);
    
    theURL = [NSURL URLWithString:urlString];
    [self.authenticationViewController makeLoginRequestWithURL:theURL];
}

// YOU NEED TO CAPTURE igAPPID:// schema
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
//    NSLog(@"application: %@, handleOpenURL: %@", application, url);
    
    return [self.instagram handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    NSLog(@"application: %@, handleOpenURL: %@, sourceApplication %@, annotation: %@", application, url, sourceApplication, annotation);
    return [self.instagram handleOpenURL:url];
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{
    if (self.appRootViewController.notificationsViewController != nil)
        [self.appRootViewController.notificationsViewController loadNotifications];
    
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];

    
}

- (void)loadShareCoverViewProfileViewController:(ProfileViewController *)theProfileViewController
{
    
    CGRect rect = CGRectMake(0,0,0,0);
    CGRect cropRect=CGRectMake(0,0,612,612);
//    NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.ig"];
    CGImageRef imageRef = CGImageCreateWithImageInRect([theProfileViewController.backgroundImageView.image CGImage], cropRect);
    UIImage *img = [UIImage imageNamed:@"cover-Default"];//[[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.ig"];
    
    BOOL writeSuccess = [UIImageJPEGRepresentation([UIImage imageNamed:@"Instagram-Promo-1.png"], 1.0) writeToFile:jpgPath atomically:YES];
    NSLog(@"writeSuccess: %d", writeSuccess);
    
    
    
    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
    self.dicot = [[UIDocumentInteractionController alloc] init];
    self.dicot.URL = igImageHookFile;
    self.dicot.delegate = self;
    self.dicot.UTI = @"com.instagram.photo";
    self.dicot.annotation = [NSDictionary dictionaryWithObject:PROMOTE_TEXT forKey:@"InstagramCaption"];
    [self.dicot presentOpenInMenuFromRect: rect  inView: [AppRootViewController sharedRootViewController].view animated: YES ];
    
    
    self.instagramShareViewController = [[InstagramShareViewController alloc] initWithNibName:@"InstagramShareViewController" bundle:nil];
    self.instagramShareViewController.view.frame = CGRectMake(0, 0, 320, 278);
    [self.window addSubview:self.instagramShareViewController.view];
    
}

- (void) socialImageSelected:(UIImage *)theImage
{
    NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.ig"];
    
    BOOL writeSuccess = [UIImageJPEGRepresentation(theImage, 1.0) writeToFile:jpgPath atomically:YES];
    NSLog(@"writeSuccess: %d", writeSuccess);
    
    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
    self.dicot.URL = igImageHookFile;
    self.dicot.delegate = self;
    self.dicot.UTI = @"com.instagram.photo";
    self.dicot.annotation = [NSDictionary dictionaryWithObject:PROMOTE_TEXT forKey:@"InstagramCaption"];
    
    NSLog(@"socialImageSelected, theImage: %@", theImage);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application{
    [self.instagramShareViewController.view removeFromSuperview];
    NSLog(@"documentInteractionController will begin sending");
    
}
- (void) documentInteractionControllerDidDismissOptionsMenu: (UIDocumentInteractionController *) controller
{
    NSLog(@"documentInteractionControllerDidDismissOptionsMenu");
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
    NSLog(@"applicationWillEnterForeground");
    [CategoriesAPIHandler makeCategoriesRequest];
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
