//
//  PurchasingViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedViewController;

@interface PurchasingViewController : UIViewController
{
    FeedViewController *parentController;
    
    NSDictionary *purchasingObject;
    
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *sellerLabel;
    UITextView *descriptionTextView;
    UILabel *priceLabel;
    UILabel *numberAvailableLabel;

}

-(IBAction)backButtonHit;
-(IBAction)buyButtonHit;

@property (nonatomic, retain) FeedViewController *parentController;

@property (nonatomic, retain) NSDictionary *purchasingObject;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberAvailableLabel;

@end
