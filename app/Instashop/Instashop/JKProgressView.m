//
//  JKProgressView.m
//  Instashop
//
//  Created by Josh Klobe on 1/20/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "JKProgressView.h"

@implementation JKProgressView


@synthesize theIndicatorView;
@synthesize theLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(JKProgressView *)presentProgressViewInView:(UIView *)referenceView withText:(NSString *)theText
{
    JKProgressView *theProgressView = [[JKProgressView alloc] initWithFrame:CGRectMake(0, 0, referenceView.frame.size.width, referenceView.frame.size.height)];
    //theProgressView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
    theProgressView.backgroundColor = [UIColor clearColor];
    
    theProgressView.theIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    theProgressView.theIndicatorView.frame = CGRectMake(referenceView.frame.size.width / 2 - theProgressView.theIndicatorView.frame.size.width / 2, referenceView.frame.size.height / 2 - theProgressView.theIndicatorView.frame.size.height / 2 - 64, theProgressView.theIndicatorView.frame.size.width, theProgressView.theIndicatorView.frame.size.height);
    [theProgressView addSubview:theProgressView.theIndicatorView];
    [theProgressView.theIndicatorView startAnimating];
    
    
    
    theProgressView.theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, theProgressView.theIndicatorView.frame.origin.y + theProgressView.theIndicatorView.frame.size.height + 4, referenceView.frame.size.width, 20)];
    theProgressView.theLabel.textColor = [UIColor darkGrayColor];
    theProgressView.theLabel.textAlignment = NSTextAlignmentCenter;
    theProgressView.theLabel.backgroundColor = [UIColor clearColor];
    theProgressView.theLabel.text = theText;
    theProgressView.theLabel.font = [UIFont  systemFontOfSize:theProgressView.theLabel.frame.size.height - 3];
    [theProgressView addSubview:theProgressView.theLabel];
    
    
    [referenceView addSubview:theProgressView];
    
    return theProgressView;
}

-(void)hideProgressView
{
    [self removeFromSuperview];
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
