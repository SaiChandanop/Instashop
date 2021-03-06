//
//  SocialManager.m
//  Instashop
//  Handler for Twitter and Facebook access and posting
//  Created by Josh Klobe on 10/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SocialManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "ProductDetailsViewController.h"

@implementation SocialManager


+(void)requestInitialFacebookAccess
{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookAccountType = [accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"email", nil];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:0];
    [options setObject:@"500395433370249" forKey:ACFacebookAppIdKey];
    [options setObject:permissionsArray forKey:ACFacebookPermissionsKey];
    [options setObject:ACFacebookAudienceFriends forKey:ACFacebookAudienceKey];
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:options completion:^(BOOL granted, NSError *theError) {
                                              
                                              
                                              NSLog(@"granted: %d, error: %@", granted, theError);
                                              
                                              
                                              if (granted) {
                                                  NSLog(@"granted!!!");
                                                  
                                                  
                                              }
                                              else
                                              {
                                                  // Handle Failure
                                              }
                                          }];
    
}

+(NSArray *)getAllTwitterAccountsWithResponseDelegate:(id)theDelegate
{    
    NSMutableArray *retAR = [NSMutableArray arrayWithCapacity:0];
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             if ([theDelegate respondsToSelector:@selector(twitterAccountsLookupDidCompleteWithArray:)])
                 [(ProductDetailsViewController *)theDelegate performSelectorOnMainThread:@selector(twitterAccountsLookupDidCompleteWithArray:) withObject:[account accountsWithAccountType:accountType] waitUntilDone:NO];
             
         }
     }];
     
    
     return retAR;
}

+(void)postToTwitterWithString:(NSString *)contentString withImage:(UIImage *)theImage
{

    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             


             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSString *preferredTwitterAccount = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_TWITTER_ACCOUNT_ID_KEY];
                 if (preferredTwitterAccount != nil)
                 {
                     for (int i = 0; i < [arrayOfAccounts count]; i++)
                     {
                         ACAccount *theAccount = [arrayOfAccounts objectAtIndex:i];
                         if ([theAccount.username compare:[[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_TWITTER_ACCOUNT_ID_KEY]] == NSOrderedSame)
                         {
                             twitterAccount = theAccount;
                         }
                     }
                 }
                 
                 NSDictionary *params = @{@"status": contentString};
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"https://api.twitter.com"
                                      @"/1.1/statuses/update_with_media.json"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:params];
                 
                 NSData *imageData = UIImageJPEGRepresentation(theImage, 1.f);
                 [postRequest addMultipartData:imageData
                                  withName:@"media[]"
                                      type:@"image/jpeg"
                                  filename:@"image.jpg"];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@"Twitter HTTP response: %i",
                            [urlResponse statusCode]);
                  }];
                 
                 
             }
             
         }
         else
             NSLog(@"access not granted");
         
         NSLog(@"twitter done");
     }];
}


+(void)postToFacebookWithString:(NSString *)contentString withImage:(UIImage *)contentImage
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookAccountType = [accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"publish_stream", nil];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:0];
    [options setObject:@"500395433370249" forKey:ACFacebookAppIdKey];
    [options setObject:permissionsArray forKey:ACFacebookPermissionsKey];
    [options setObject:ACFacebookAudienceFriends forKey:ACFacebookAudienceKey];
    
    
    NSString *feedURLString = @"https://graph.facebook.com/me/feed";
    if (contentImage != nil)
        feedURLString = @"https://graph.facebook.com/me/photos";
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                     options:options
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             
             NSArray *arrayOfAccounts = [accountStore
                                         accountsWithAccountType:facebookAccountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *facebookAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSDictionary *message = @{@"message": contentString};
                 
                 
                 NSURL *feedURL = [NSURL URLWithString:feedURLString];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeFacebook
                                           requestMethod:SLRequestMethodPOST
                                           URL:feedURL parameters:message];
                 
                 if (contentImage != nil)
                 {
                     NSData *imageData = UIImagePNGRepresentation(contentImage);
                     [postRequest addMultipartData:imageData withName:@"picture" type:@"image/png" filename:nil];
                 }
                 
                 postRequest.account = facebookAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      
                                                NSString* newStr = [[NSString alloc] initWithData:responseData
                                                                                        encoding:NSUTF8StringEncoding];
                      
                      NSLog(@"facebook response string: %@", newStr);
                      NSLog(@"facebook error: %@", error);
                  }];
             }
             else
             {
                 UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                     message:@"To post to Facebook you need to head over to Settings and update your Facebook credentials"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             
         }
         else
             NSLog(@"facebook access not granted, error: %@", error);
     }];
}
@end
