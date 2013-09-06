//
//  CreateSellerTutorialView.m
//  Instashop
//
//  Created by Susan Yee on 9/6/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CreateSellerTutorialView.h"

@implementation CreateSellerTutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
        [self addSubview:backgroundImage];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
