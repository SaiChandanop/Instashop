//
//  SuggestedShopView.m
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SuggestedShopView.h"
#import "AppDelegate.h"
#import "SuggestedStoresViewController.h"
#import "ImageAPIHandler.h"
#import "Flurry.h"
#import "InstagramUserObject.h"
@implementation SuggestedShopView

@synthesize parentController;
@synthesize shopViewInstagramID;
@synthesize titleLabel;
@synthesize bioLabel;
@synthesize theBackgroundImageView;
@synthesize profileImageView;
@synthesize followButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        // Initialization code
        
    }
    return self;
}


-(IBAction)followButtonHit
{
    [self shopFollowButtonHitWithID:self.shopViewInstagramID withIsSelected:self.followButton.selected];
    
    if (self.followButton.selected)
    {
        NSString *flurryString = [NSString stringWithFormat:@"User unfollowed"];
        NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:self.shopViewInstagramID, @"userID", nil];
        [Flurry logEvent:flurryString withParameters:flurryParams];
    }
    else
    {
        
        NSString *flurryString = [NSString stringWithFormat:@"User followed"];
        NSDictionary *flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:self.shopViewInstagramID, @"userID", nil];
        [Flurry logEvent:flurryString withParameters:flurryParams];
    }
    
}

-(IBAction)viewButtonHit
{
    [self.parentController shopViewButtonHitWithID:self.shopViewInstagramID];
}

-(void) makeIGContentRequest
{
//    NSLog(@"makeIGContentRequest: %@", self.shopViewInstagramID);
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.shopViewInstagramID], @"method", nil];
    [delegate.instagram requestWithParams:params delegate:self];
        
    
    if ([self.shopViewInstagramID compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
        [self.followButton removeFromSuperview];
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
     NSDictionary *dataDictionary = [result objectForKey:@"data"];
    

//    NSLog(@"request didLoad: %@", self.shopViewInstagramID);
    
    if ([request.url rangeOfString:@"relationship"].length > 0)
    {
        if (![dataDictionary isKindOfClass:[NSNull class]])
        {
        NSString *outgoingStatus = [dataDictionary objectForKey:@"outgoing_status"];
        if ([outgoingStatus compare:@"follows"] == NSOrderedSame)
        {
            self.followButton.selected = YES;
            [self.parentController.firstTimeUserViewController performSelectorOnMainThread:@selector(shopWasFollowed) withObject:nil waitUntilDone:NO];
        }
        else
        {
            self.followButton.selected = NO;
        }
        
        self.followButton.alpha = 1;
        }
        
    }
    else if ([request.url rangeOfString:@"users"].length > 0)
    {
        self.bioLabel.text = [dataDictionary objectForKey:@"bio"];
        self.titleLabel.text = [dataDictionary objectForKey:@"full_name"];
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
        self.profileImageView.layer.masksToBounds = YES;
        [ImageAPIHandler makeImageRequestWithDelegate:nil withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.profileImageView];
        [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.theBackgroundImageView withInstagramID:self.shopViewInstagramID];
        
        self.followButton.alpha = 0;
        [self.parentController selectedShopViewDidCompleteRequestWithView:self];
//        [self.parentController performSelectorOnMainThread:@selector(selectedShopViewDidCompleteRequestWithView:) withObject:self waitUntilDone:NO];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/relationship", [dataDictionary objectForKey:@"id"]], @"method", nil];
        [delegate.instagram requestWithParams:params delegate:self];
        
    }
    
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request didFailWithError: %@, %@", self.shopViewInstagramID, error);
    
    [self.parentController performSelectorOnMainThread:@selector(selectedShopViewDidCompleteRequestWithView:) withObject:self waitUntilDone:NO];
}
-(void)shopFollowButtonHitWithID:(NSString *)instagramID withIsSelected:(BOOL)isSelected
{
//    NSLog(@"shopFollowButtonHitWithID: %@", instagramID);
    
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.followButton.selected = !isSelected;
    
    if (isSelected)
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", instagramID], @"method", @"unfollow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
        
        [self.parentController.firstTimeUserViewController performSelectorOnMainThread:@selector(shopWasUnFollowed) withObject:nil waitUntilDone:NO];
        
    }
    else
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", instagramID], @"method", @"follow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];

    }
}



@end
