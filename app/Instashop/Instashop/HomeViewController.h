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
    
    UIView *termsView;
    
    UIView *topBarView;
    
    
}


-(IBAction) tempSellerButtonHit;
-(void)createSellerCancelButtonHit:(UINavigationController *)theNavigationController;
-(void)createSellerDone:(UINavigationController *)theNavigationController;
-(void)loadStates;
-(IBAction)homeButtonHit;
-(IBAction)profileButtonHit;
-(IBAction)logOutButtonHit;
-(IBAction)suggestedShopButtonHit;


@property (nonatomic, retain) AppRootViewController *parentController;

@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;

@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;

@property (nonatomic, retain) IBOutlet UIView *termsView;

@property (nonatomic, retain) IBOutlet UIView *logoutView;

@property (nonatomic, retain) IBOutlet UIView *topBarView;
@end
