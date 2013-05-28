//
//  ProductCreateViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCreateViewController : UIViewController
{
    UITextField *quantityTextField;
    UITextField *modelTextField;
    UITextField *priceTextField;
    UITextField *weightField;
    
    NSDictionary *productDictionary;
}

-(IBAction)goButtonHit;


@property (nonatomic, retain) IBOutlet UITextField *quantityTextField;
@property (nonatomic, retain) IBOutlet UITextField *modelTextField;
@property (nonatomic, retain) IBOutlet UITextField *priceTextField;
@property (nonatomic, retain) IBOutlet UITextField *weightField;

@property (nonatomic, retain) NSDictionary *productDictionary;
@end
