//
//  InterestsViewController.h
//  Instashop
//
//  Created by Josh Klobe on 3/25/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EnterEmailViewController;

@interface InterestsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *theTableView;
    NSMutableArray *selectionsArray;
    EnterEmailViewController *theParentController;
}

@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) NSMutableArray *selectionsArray;
@property (nonatomic, retain) EnterEmailViewController *theParentController;
@end
