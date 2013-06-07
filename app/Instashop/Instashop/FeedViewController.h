//
//  FeedViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppRootViewController;
@interface FeedViewController : UIViewController
{
  AppRootViewController *parentController;
    
    UIView *headerView;
    
}


-(IBAction)homeButtonHit;
-(IBAction)notificationsButtonHit;
-(IBAction)discoverButtonHit;


@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet UIView *headerView;

@end
