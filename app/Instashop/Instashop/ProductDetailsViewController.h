//
//  ProductDetailsViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductCreateViewController;

@interface ProductDetailsViewController : UIViewController
{
    ProductCreateViewController *parentController;
    
    UIScrollView *containerScrollView;
    
    UIImageView *productImageView;
}

- (IBAction) backButtonHit;
- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary;

@property (nonatomic, retain) ProductCreateViewController *parentController;

@property (nonatomic, retain) IBOutlet UIScrollView *containerScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@end
