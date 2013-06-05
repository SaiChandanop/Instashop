//
//  ProductPreviewViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCreateObject.h"
@interface ProductPreviewViewController : UIViewController
{
    ProductCreateObject *productCreateObject;
    
    UIScrollView *theScrollView;
    
    UIImageView *productImageView;
    UILabel *titleLabel;
    UITextField *descriptionTextField;
    
}

@property (nonatomic, retain) ProductCreateObject *productCreateObject;

@property (nonatomic, retain) UIScrollView *theScrollView;

@property (nonatomic, retain) IBOutlet UIImageView *productImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextField *descriptionTextField;

@end
