//
//  SocialManager.m
//  Instashop
//
//  Created by Josh Klobe on 10/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SocialManager.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


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

+(void)postToTwitterWithString:(NSString *)contentString
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
                 
                 NSDictionary *message = @{@"status": contentString};
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:message];
                 
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

+(void)postToFacebookWithString:(NSString *)contentString
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *facebookAccountType = [accountStore
                                          accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"publish_stream", nil];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:0];
    [options setObject:@"500395433370249" forKey:ACFacebookAppIdKey];
    [options setObject:permissionsArray forKey:ACFacebookPermissionsKey];
    [options setObject:ACFacebookAudienceFriends forKey:ACFacebookAudienceKey];
    
    
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
                 
                 
                 NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeFacebook
                                           requestMethod:SLRequestMethodPOST
                                           URL:feedURL parameters:message];
                 
                 postRequest.account = facebookAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      
                      //                          NSString* newStr = [[[NSString alloc] initWithData:responseData
                      //                                                                  encoding:NSUTF8StringEncoding] autorelease];
                      
                      //NSLog(@"facebook response string: %@", newStr);
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
