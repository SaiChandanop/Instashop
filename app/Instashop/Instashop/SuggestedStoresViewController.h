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
#import "SuggestedShopView.h"

@class AppRootViewController;

@class FirstTimeUserViewController;

@interface SuggestedStoresViewController : UIViewController <SuggestedShopReturnProtocol, IGRequestDelegate>
{
    AppRootViewController *appRootViewController;
    FirstTimeUserViewController *firstTimeUserViewController;
    
    UIScrollView *contentScrollView;
    UIButton *closeTutorialButton;
    
    NSMutableArray *selectedShopsIDSArray;
    NSMutableDictionary *containerViewsDictionary;
    NSMutableArray *followedIDsArray;
    
    BOOL isLaunchedFromMenu;
    
}

-(void) selectedShopViewDidCompleteRequestWithView:(SuggestedShopView *)theShopView;
-(void) updateButton;
-(void) shopFollowButtonHitWithID:(NSString *)instagramID withIsSelected:(BOOL)isSelected;
-(void) shopViewButtonHitWithID:(NSString *)instagramID;

@property (nonatomic, retain) AppRootViewController *appRootViewController;
@property (nonatomic, retain) FirstTimeUserViewController *firstTimeUserViewController;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain) UIButton *closeTutorialButton;

@property (nonatomic, retain) NSMutableArray *selectedShopsIDSArray;
@property (nonatomic, retain) NSMutableDictionary *containerViewsDictionary;
@property (nonatomic, retain) NSMutableArray *followedIDsArray;

@property (nonatomic, assign) BOOL isLaunchedFromMenu;

@end
