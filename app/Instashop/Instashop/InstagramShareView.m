//
//  InstagramShareView.m
//  Instashop
//
//  Created by Josh Klobe on 1/8/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "InstagramShareView.h"
#import "AppDelegate.h"

@implementation InstagramShareView

@synthesize theScrollView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.theScrollView];
        
        float xOffset = 0;
        
        
        for (int i = 1; i < 6; i++)
        {
            UIImage *theImage = [UIImage imageNamed:[NSString stringWithFormat:@"Instagram-Promo-%d", i]];
            
            UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0, self.theScrollView.frame.size.height, self.theScrollView.frame.size.height)];
            theImageView.image = theImage;
            [self.theScrollView addSubview:theImageView];
            
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            aButton.frame = CGRectMake(xOffset, 0, self.theScrollView.frame.size.height, self.theScrollView.frame.size.height);
            aButton.tag = i;
            [aButton addTarget:self action:@selector(aButtonHit:) forControlEvents:UIControlEventTouchUpInside];
            [self.theScrollView addSubview:aButton];
            
            xOffset = theImageView.frame.origin.x + theImageView.frame.size.width;
        }
        
        self.theScrollView.contentSize = CGSizeMake(xOffset, self.theScrollView.frame.size.height);
        // Initialization code
    }
    return self;
}

-(void)aButtonHit:(UIButton *)sender
{
    NSLog(@"aButtonHit, sender.tag: %d", sender.tag);
    UIImage *theImage = [UIImage imageNamed:[NSString stringWithFormat:@"Instagram-Promo-%d", sender.tag]];
    NSLog(@"theImage: %@", theImage);
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del socialImageSelected:theImage];
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
