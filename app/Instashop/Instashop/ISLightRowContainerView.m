//
//  ISLightRowContainerView.m
//  Instashop
//
//  Created by Josh Klobe on 8/21/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ISLightRowContainerView.h"

@implementation ISLightRowContainerView

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

    [super drawRect:rect];
    
    UIImage *separatorImage = [UIImage imageNamed:@"cell_separator.png"];
    UIImageView *separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, separatorImage.size.height)];
    separatorImageView.image = separatorImage;
    [self addSubview:separatorImageView];
    
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    self.backgroundImageView.image = [UIImage imageNamed:@"menuLightBG.png"];
    [self insertSubview:self.backgroundImageView atIndex:0];

    
    // Drawing code
}


@end
