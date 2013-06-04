//
//  HomeViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppRootViewController;
@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    AppRootViewController *parentController;
    
    UITableView *theTableView;
}
@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@end