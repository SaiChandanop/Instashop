//
//  SuggestedStoresViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppRootViewController;

@interface SuggestedStoresViewController : UIViewController
{
    AppRootViewController *appRootViewController;
    
    UIScrollView *contentScrollView;
}

@property (nonatomic, retain) AppRootViewController *appRootViewController;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;
@end
