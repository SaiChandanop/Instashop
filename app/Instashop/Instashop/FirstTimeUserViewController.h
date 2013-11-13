//
//  FirstTimeUserViewController.h
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppRootViewController;

@class SuggestedStoresViewController;

@interface FirstTimeUserViewController : UIViewController <UIScrollViewDelegate>

- (void) closeTutorial;
- (void) moveScrollView;

@property (nonatomic, retain) UIScrollView *tutorialScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) AppRootViewController *parentViewController;
@property (nonatomic, retain) SuggestedStoresViewController *suggestedStoresViewController;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *loginTutorialDone;

@end
