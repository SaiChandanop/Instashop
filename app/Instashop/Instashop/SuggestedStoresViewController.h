//
//  SuggestedStoresViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestedShopReturnProtocol.h"
#import "Instagram.h"
@class AppRootViewController;

@interface SuggestedStoresViewController : UIViewController <SuggestedShopReturnProtocol, IGRequestDelegate>
{
    AppRootViewController *appRootViewController;
    
    UIScrollView *contentScrollView;
    
    NSMutableArray *selectedShopsIDSArray;
    NSMutableArray *containerViewsArray;
    
    
}

@property (nonatomic, retain) AppRootViewController *appRootViewController;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, retain) NSMutableArray *selectedShopsIDSArray;
@property (nonatomic, retain) NSMutableArray *containerViewsArray;

@end
