//
//  FeedViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellSelectionOccuredProtocol.h"
#import "FeedRequestFinishedProtocol.h"

@class AppRootViewController;

@interface FeedViewController : UITableViewController <CellSelectionOccuredProtocol, FeedRequestFinishedProtocol>
{
    AppRootViewController *parentController;
    
    NSMutableArray *feedItemsArray;
    
    id selectedObject;
}

-(void)purchasingViewControllerBackButtonHitWithVC:(UIViewController *)vc;


@property (nonatomic, retain) AppRootViewController *parentController;


@property (nonatomic, retain) NSMutableArray *feedItemsArray;

@property (nonatomic, retain) id selectedObject;
@end
