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
    BOOL emailComplete;
    CGRect nextButtonFrame;
}
- (void) closeTutorial;
- (void) moveScrollView;
- (void) shopWasFollowed;
-(void)emailPageComplete;

@property (nonatomic, strong) UIScrollView *tutorialScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) AppRootViewController *parentViewController;
@property (nonatomic, strong) EnterEmailViewController *enterEmailViewController;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, retain) UIButton *suggestedButton;
@property (nonatomic, strong) UIButton *loginTutorialDone;
@property (nonatomic, assign) BOOL emailComplete;
@property (nonatomic, assign) CGRect nextButtonFrame;

@end
