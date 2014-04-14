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
    
    theProgressView.theIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    theProgressView.theIndicatorView.frame = CGRectMake(referenceView.frame.size.width / 2 - theProgressView.theIndicatorView.frame.size.width / 2, referenceView.frame.size.height / 2 - theProgressView.theIndicatorView.frame.size.height / 2 - 64, theProgressView.theIndicatorView.frame.size.width, theProgressView.theIndicatorView.frame.size.height);
    [theProgressView addSubview:theProgressView.theIndicatorView];
    [theProgressView.theIndicatorView startAnimating];
    
    
    
    theProgressView.theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, theProgressView.theIndicatorView.frame.origin.y + theProgressView.theIndicatorView.frame.size.height + 4, referenceView.frame.size.width, 20)];
    theProgressView.theLabel.textColor = [UIColor whiteColor];
    theProgressView.theLabel.textAlignment = NSTextAlignmentCenter;
    theProgressView.theLabel.backgroundColor = [UIColor clearColor];
    theProgressView.theLabel.text = theText;
    theProgressView.theLabel.font = [UIFont systemFontOfSize:theProgressView.theLabel.frame.size.height - 7];
    [theProgressView addSubview:theProgressView.theLabel];
    
    
    [referenceView addSubview:theProgressView];
    
    float boxRadius = 34;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(theProgressView.theIndicatorView.frame.origin.x + theProgressView.theIndicatorView.frame.size.width / 2 - boxRadius*1.5, theProgressView.theIndicatorView.frame.origin.y + theProgressView.theIndicatorView.frame.size.height / 2 - boxRadius, boxRadius  * 3, boxRadius *2.5)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.75];
    bgView.layer.cornerRadius = 8.0;
    bgView.layer.masksToBounds = YES;
    [theProgressView insertSubview:bgView atIndex:0];
    
    return theProgressView;
}


+(JKProgressView *)presentProgressViewInView:(UIView *)referenceView withText:(NSString *)theText withImageType:(int)type
{
    JKProgressView *theProgressView = [[JKProgressView alloc] initWithFrame:CGRectMake(0, 0, referenceView.frame.size.width, referenceView.frame.size.height)];
    //theProgressView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
    theProgressView.backgroundColor = [UIColor clearColor];
    
    float diameter = 68;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(referenceView.frame.size.width / 2 - diameter / 2, referenceView.frame.size.height / 2 - diameter /2, diameter, diameter)];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.75];
    bgView.layer.cornerRadius = 8.0;
    bgView.layer.masksToBounds = YES;
    [theProgressView insertSubview:bgView atIndex:0];
    
    float inset = bgView.frame.size.width * .08;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width / 2 - (bgView.frame.size.width / 2 * inset), inset, bgView.frame.size.width / 2 * inset, bgView.frame.size.width / 2 * inset)];
    theImageView.image = [UIImage imageNamed:@"heart_red.png"];
    [bgView addSubview:theImageView];
 
    
    
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
