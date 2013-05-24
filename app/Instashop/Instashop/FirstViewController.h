//
//  FirstViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"


@interface FirstViewController : UIViewController <IGSessionDelegate, IGRequestDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *userMediaArray;
    UITableView *theTableView;
}
@property (nonatomic, retain) NSMutableArray *userMediaArray;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@end
