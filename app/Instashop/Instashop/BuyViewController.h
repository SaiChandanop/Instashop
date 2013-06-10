//
//  BuyViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyViewController : UIViewController
{
    UIScrollView *contentScrollView;
 
    UITextField *creditCardTextField;
    UITextField *monthExpirationField;
    UITextField *yearExpirationField;
    UITextField *ccvTextField;
    
}

-(IBAction)backButtonHit;
-(IBAction)buyButtonHit;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, retain) IBOutlet UITextField *creditCardTextField;
@property (nonatomic, retain) IBOutlet UITextField *monthExpirationField;
@property (nonatomic, retain) IBOutlet UITextField *yearExpirationField;
@property (nonatomic, retain) IBOutlet UITextField *ccvTextField;

@end
