//
//  ProductPreviewViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCreateContainerObject.h"

@class  ProductCreateViewController;

@interface ProductPreviewViewController : UIViewController
{
    ProductCreateViewController *parentController;
    
    ProductCreateContainerObject *productCreateContainerObject;
    UIScrollView *theScrollView;
    
    UIImageView *productImageView;
    UILabel *titleLabel;
    UITextView *descriptionTextField;
    
}

-(void)loadWithProductCreateObject:(ProductCreateContainerObject *)theProductCreateContainerObject;

- (IBAction) backButtonHit;
- (IBAction) postButtonHit;

@property (nonatomic, retain) ProductCreateViewController *parentController;

@property (nonatomic, retain) ProductCreateContainerObject *productCreateContainerObject;

@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextField;

@end
