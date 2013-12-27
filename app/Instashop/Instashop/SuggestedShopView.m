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
}

-(IBAction)viewButtonHit
{
    [self.parentController shopViewButtonHitWithID:self.shopViewInstagramID];
}

-(void) makeIGContentRequest
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.shopViewInstagramID], @"method", nil];
    [delegate.instagram requestWithParams:params delegate:self];    
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
     NSDictionary *dataDictionary = [result objectForKey:@"data"];
    
    if ([request.url rangeOfString:@"users"].length > 0)
    {
        self.bioLabel.text = [dataDictionary objectForKey:@"bio"];
        self.titleLabel.text = [dataDictionary objectForKey:@"full_name"];
        //shopView.bioLabel.numberOfLines = 0;
        //shopView.bioLabel.font = [UIFont systemFontOfSize:8];
        [ImageAPIHandler makeImageRequestWithDelegate:nil withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.profileImageView];
        [ImageAPIHandler makeProfileImageRequestWithReferenceImageView:self.theBackgroundImageView withInstagramID:self.shopViewInstagramID];
        
        [self.parentController selectedShopViewDidCompleteRequestWithView:self];
        
        self.followButton.alpha = 1;
    }
    
}


-(void)shopFollowButtonHitWithID:(NSString *)instagramID withIsSelected:(BOOL)isSelected
{
    NSLog(@"shopFollowButtonHitWithID: %@", instagramID);
    
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (isSelected)
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", instagramID], @"method", @"unfollow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
    }
    else
    {
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"/users/%@/relationship", instagramID], @"method", @"follow", @"action", nil];
        [theAppDelegate.instagram postRequestWithParams:params delegate:self];
    }
}



@end
