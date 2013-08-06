//
//  PurchasingViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizePickerViewViewController.h"
@class FeedViewController;

@interface PurchasingViewController : UIViewController
{
    FeedViewController *parentController;
    SizePickerViewViewController *sizePickerViewViewController;
    
    NSString *requestingProductID;
    NSDictionary *requestedPostmasterDictionary;
    
    UIScrollView *contentScrollView;
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *sellerLabel;
    UILabel *categoryLabel;
    UIView *descriptionContainerView;
    UITextView *descriptionTextView;
    UILabel *priceLabel;
    UILabel *numberAvailableLabel;
    UIImageView *sellerProfileImageView;
    UIButton *sizeButton;
    UIButton *quantityButton;
    
    UIButton *purchaseButton;
    
    int sizeSelectedIndex;
}

-(IBAction)backButtonHit;
-(IBAction)buyButtonHit;

-(IBAction)sizeButtonHit;
-(IBAction)quantityButtonHit;

@property (nonatomic, retain) FeedViewController *parentController;
@property (nonatomic, retain) SizePickerViewViewController *sizePickerViewViewController;

@property (nonatomic, retain) NSString *requestingProductID;
@property (nonatomic, retain) NSDictionary *requestedPostmasterDictionary;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic, retain) IBOutlet UIView *descriptionContainerView;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberAvailableLabel;
@property (nonatomic, retain) IBOutlet UIImageView *sellerProfileImageView;
@property (nonatomic, retain) IBOutlet UIButton *sizeButton;
@property (nonatomic, retain) IBOutlet UIButton *quantityButton;

@property (nonatomic, retain) IBOutlet UIButton *purchaseButton;
@property (nonatomic, retain) IBOutlet UIView *bottomView;

@property (nonatomic, assign) int sizeSelectedIndex;
@end
