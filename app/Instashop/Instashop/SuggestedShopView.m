//
//  SuggestedShopView.m
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SuggestedShopView.h"
#import "AppDelegate.h"

@implementation SuggestedShopView


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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];        
}
@end
