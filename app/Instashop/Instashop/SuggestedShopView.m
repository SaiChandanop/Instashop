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
    [self.parentController shopFollowButtonHitWithID:self.shopViewInstagramID withIsSelected:self.followButton.selected];
}

-(IBAction)viewButtonHit
{
    [self.parentController shopViewButtonHitWithID:self.shopViewInstagramID];
}

@end
