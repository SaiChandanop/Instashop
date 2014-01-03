//
//  FirstTimeUserViewController.h
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterEmailViewController.h"

@class AppRootViewController;

@class SuggestedStoresViewController;

@interface FirstTimeUserViewController : UIViewController <UIScrollViewDelegate>
{
    int suggestedFollowCount;
}
- (void) closeTutorial;
- (void) moveScrollView;
- (void) shopWasFollowed;
@property (nonatomic, retain) UIScrollView *tutorialScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) AppRootViewController *parentViewController;
@property (nonatomic, retain) SuggestedStoresViewController *suggestedStoresViewController;
@property (nonatomic, retain) EnterEmailViewController *enterEmailViewController;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *loginTutorialDone;
@property (nonatomic, assign) int suggestedFollowCount;

@end
