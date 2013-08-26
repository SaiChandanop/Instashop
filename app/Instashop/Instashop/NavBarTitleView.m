//
//  NavBarTitleView.m
//  Instashop
//
//  Created by Josh Klobe on 8/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NavBarTitleView.h"

@implementation NavBarTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(NavBarTitleView *)getTitleViewWithTitleString:(NSString *)titleString
{
    NavBarTitleView *theView = [[NavBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    theView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,1, theView.frame.size.width, theView.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [theView addSubview:titleLabel];
    
    return theView;
}




@end
