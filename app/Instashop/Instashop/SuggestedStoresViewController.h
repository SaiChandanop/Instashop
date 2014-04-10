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

@interface SuggestedStoresViewController : UITableViewController <SuggestedShopReturnProtocol, IGRequestDelegate, UIScrollViewDelegate>
{
    AppRootViewController *appRootViewController;
    FirstTimeUserViewController *firstTimeUserViewController;
    
    UIScrollView *tempScrollView;
    UIScrollView *brandsScrollView;
    UIScrollView *bloggersScrollView;
    UIButton *closeTutorialButton;
    UISegmentedControl *segmentedControl;
    UIImageView *bgImageView;
    UITableView *spoofTableView;
    NSMutableArray *shopViewsArray;
    NSMutableArray *followedIDsArray;
    UIRefreshControl *refreshControl;
    
    BOOL isLaunchedFromMenu;
    BOOL begun;
    BOOL holdBegin;
}

-(void) selectedShopViewDidCompleteRequestWithView:(SuggestedShopView *)theShopView;
-(void) updateButton;
-(void) shopFollowButtonHitWithID:(NSString *)instagramID withIsSelected:(BOOL)isSelected;
-(void) shopViewButtonHitWithID:(NSString *)instagramID;

@property (nonatomic, strong) AppRootViewController *appRootViewController;
@property (nonatomic, strong) FirstTimeUserViewController *firstTimeUserViewController;

@property (nonatomic, strong) IBOutlet UIScrollView *tempScrollView;
@property (nonatomic, strong) UIScrollView *brandsScrollView;
@property (nonatomic, strong) UIScrollView *bloggersScrollView;
@property (nonatomic, strong) UIButton *closeTutorialButton;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UITableView *spoofTableView;
@property (nonatomic, strong) NSMutableArray *shopViewsArray;
@property (nonatomic, strong) NSMutableArray *followedIDsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, assign) BOOL isLaunchedFromMenu;

@property (nonatomic, assign) BOOL begun;
@property (nonatomic, assign) BOOL holdBegin;

@end

