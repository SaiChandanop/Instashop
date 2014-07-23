//
//  PullAccountHandler.m
//  Instashop
//  Backdoor handler to get a users follows
//  Created by Josh Klobe on 3/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "PullAccountHandler.h"
#import "InstagramUserObject.h"
#import "AppDelegate.h"
#import "PaginationAPIHandler.h"
#import "AppRootViewController.h"

@implementation PullAccountHandler

@synthesize followingArray;

-(void)pullAccount
{
    self.followingArray = [[NSMutableArray alloc] initWithCapacity:0];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/self/follows", @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    AppRootViewController *rootVC = [AppRootViewController sharedRootViewController];
    self.jkProgressView = [JKProgressView presentProgressViewInView:rootVC.view withText:@"Loading..."];
    
    
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)result];
    
    NSArray *dataArray = [result objectForKey:@"data"];
    [self.followingArray addObjectsFromArray:dataArray];
    
    BOOL paginate = NO;
    NSDictionary *paginationDictionary = [dict objectForKey:@"pagination"];
    
    if (paginationDictionary != nil)
    {
        NSString *nextURLString = [paginationDictionary objectForKey:@"next_url"];
        
        if (nextURLString != nil)
        {
            [PaginationAPIHandler makePaginationRequestWithDelegate:self withRequestURLString:nextURLString];
            paginate = YES;
        }
    }
    
    if (!paginate)
        [self composeAndMail];
}

-(void)composeAndMail
{
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [self.followingArray count]; i++)
    {
        NSDictionary *dict = [self.followingArray objectAtIndex:i];
        [str appendString:[dict objectForKey:@"username"]];
        [str appendString:@"\r"];
    }
    
    AppRootViewController *rootVC = [AppRootViewController sharedRootViewController];
    [self.jkProgressView hideProgressView];
    
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = rootVC;
    [mailer setSubject:@"CSV File"];
    [mailer addAttachmentData:[str dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/csv" fileName:@"Name.csv"];
    [rootVC presentViewController:mailer animated:YES completion:nil];
    
}


@end


