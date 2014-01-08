//
//  DiscoverViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellersRequestFinishedProtocol.h"
#import "DiscoverTableViewController.h"
#import "CellSelectionOccuredProtocol.h"

@class AppRootViewController;
@interface DiscoverViewController : UIViewController <SellersRequestFinishedProtocol, CellSelectionOccuredProtocol>
{
    AppRootViewController *parentController;
    DiscoverTableViewController *discoverTableViewController;
}
@property (nonatomic, strong) AppRootViewController *parentController;
@property (nonatomic, strong) DiscoverTableViewController *discoverTableViewController;
@end
