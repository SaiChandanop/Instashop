//
//  FirstTimeUserViewController.h
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTimeUserViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *tutorialScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@end
