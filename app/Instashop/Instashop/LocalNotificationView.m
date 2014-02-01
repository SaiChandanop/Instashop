//
//  LocalNotificationView.m
//  Instashop
//
//  Created by Josh Klobe on 2/1/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "LocalNotificationView.h"
#import "AppDelegate.h"
#import "AppRootViewController.h"
@implementation LocalNotificationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(void)presentWithMessage:(NSString *)theMessage
{
    float height = 60;
    NSLog(@"theMessage: %@", theMessage);
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController *appRootViewController = appDelegate.appRootViewController;
    LocalNotificationView *localNotificationView = [[LocalNotificationView alloc] initWithFrame:CGRectMake(0,-height,appRootViewController.view.frame.size.width, height)];
    localNotificationView.backgroundColor = [UIColor blackColor];

    UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, localNotificationView.frame.size.width, localNotificationView.frame.size.height)];
    theLabel.backgroundColor = [UIColor clearColor];
    theLabel.font = [UIFont systemFontOfSize:12];
    theLabel.text = theMessage;
    theLabel.textAlignment = NSTextAlignmentCenter;
    theLabel.textColor = [UIColor whiteColor];
    [localNotificationView addSubview:theLabel];
    
    [localNotificationView presentInView:appRootViewController.view];
}

-(void)presentInView:(UIView *)theView
{
    [theView addSubview:self];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];

    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

-(void)hide
{
    NSLog(@"hide");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didHide)];
    self.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)didHide
{
    [self removeFromSuperview];
}


@end
