//
//  ISAsynchImageView.m
//  Instashop
//
//  Created by Josh Klobe on 8/19/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ISAsynchImageView.h"

@implementation ISAsynchImageView

@synthesize imageLoadingIndicatorView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)beginAnimations
{
    if (self.imageLoadingIndicatorView == nil)
    {
        self.imageLoadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.imageLoadingIndicatorView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.imageLoadingIndicatorView];
    }
    [self.imageLoadingIndicatorView startAnimating];
}

-(void)ceaseAnimations
{
    NSLog(@"ceaseAnimations!");
    [self.imageLoadingIndicatorView stopAnimating];
    [self.imageLoadingIndicatorView removeFromSuperview];
}
@end
