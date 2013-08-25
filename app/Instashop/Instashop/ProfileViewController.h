//
//  ProfileViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"
#import "FeedRequestFinishedProtocol.h"
#import "ProductSelectTableViewController.h"
#import "CellSelectionOccuredProtocol.h"

@interface ProfileViewController : UIViewController <IGRequestDelegate, CellSelectionOccuredProtocol>
{
    NSString *profileInstagramID;
    
    UIImageView *backgroundImageView;
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    UILabel *followersLabel;
    UILabel *followingLabel;
    
    ProductSelectTableViewController *productSelectTableViewController;
    UITableView *theTableView;
    
}

-(void)loadNavigationControlls;

@property (nonatomic, retain) NSString *profileInstagramID;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *followersLabel;
@property (nonatomic, retain) IBOutlet UILabel *followingLabel;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@end
