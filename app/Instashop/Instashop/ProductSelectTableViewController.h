//
//  ProductSelectTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectSelectTableViewController.h"
#import "JKProgressView.h"

@class ProfileViewController;

@interface ProductSelectTableViewController : ObjectSelectTableViewController<UIScrollViewDelegate>
{
    int checkCountup;
    NSMutableArray *cacheArray;
    BOOL loaded;
    JKProgressView *jkProgressView;
    float offsetJKProgressView;
    ProfileViewController *profileViewController;
    BOOL stifleFlashRefresh;
    
    NSString *nextURLString;
    BOOL fetchingAPI;
    UIActivityIndicatorView *spinnerFooter;
    NSMutableArray *fullArray;
    NSString *paginationId;
    
}

-(void)checkFinishedWithBoolValue:(BOOL)exists withDictionary:(NSMutableDictionary *)referenceDictionary;



@property (nonatomic, assign) int checkCountup;
@property (nonatomic, strong) NSMutableArray *cacheArray;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, strong) JKProgressView *jkProgressView;
@property (nonatomic, strong) ProfileViewController *profileViewController;
@property (nonatomic, assign) float offsetJKProgressView;
@property (nonatomic, assign) BOOL stifleFlashRefresh;
@end
