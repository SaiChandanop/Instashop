//
//  ISLightRowContainerView.m
//  Instashop
//  Used as background for containing content in the product detail view
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



- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    UIImage *separatorImage = [UIImage imageNamed:@"cell_separator.png"];
    self.separatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, separatorImage.size.height)];
    self.separatorImageView.image = separatorImage;
    [self addSubview:self.separatorImageView];
    
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    self.backgroundImageView.image = [UIImage imageNamed:@"menuLightBG.png"];
    [self insertSubview:self.backgroundImageView atIndex:0];

    
    // Drawing code
}


@end
