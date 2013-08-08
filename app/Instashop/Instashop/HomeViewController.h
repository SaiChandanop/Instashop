//
//  HomeViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppRootViewController;
@interface HomeViewController : UIViewController 
{
    AppRootViewController *parentController;
    UIScrollView *theScrollView;
    UILabel *sellerLabel;
    
}


-(void)createSellerCancelButtonHit;
-(void)createSellerDone;
-(void)loadStates;
-(IBAction)homeButtonHit;

@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;

@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;
@end
