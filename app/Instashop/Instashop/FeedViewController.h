//
//  FeedViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppRootViewController;
@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    AppRootViewController *parentController;

    UIView *headerView;
    UITableView *theTableView;
    
    NSMutableArray *feedItemsArray;
    
    id selectedObject;
}


-(IBAction)homeButtonHit;
-(IBAction)notificationsButtonHit;
-(IBAction)discoverButtonHit;

-(void)purchasingViewControllerBackButtonHitWithVC:(UIViewController *)vc;


@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;

@property (nonatomic, retain) NSMutableArray *feedItemsArray;

@property (nonatomic, retain) id selectedObject;
@end
