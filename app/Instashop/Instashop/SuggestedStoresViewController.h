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
    NSMutableArray *shopViewsArray;
    NSMutableArray *followedIDsArray;
    
    BOOL isLaunchedFromMenu;
    
    BOOL begun;
}

-(void) selectedShopViewDidCompleteRequestWithView:(SuggestedShopView *)theShopView;
-(void) updateButton;
-(void) shopFollowButtonHitWithID:(NSString *)instagramID withIsSelected:(BOOL)isSelected;
-(void) shopViewButtonHitWithID:(NSString *)instagramID;

@property (nonatomic, strong) AppRootViewController *appRootViewController;
@property (nonatomic, strong) FirstTimeUserViewController *firstTimeUserViewController;

@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *closeTutorialButton;

@property (nonatomic, strong) NSMutableArray *selectedShopsIDSArray;
@property (nonatomic, strong) NSMutableArray *shopViewsArray;
@property (nonatomic, strong) NSMutableArray *followedIDsArray;

@property (nonatomic, assign) BOOL isLaunchedFromMenu;

@property (nonatomic, assign) BOOL begun;
@end

