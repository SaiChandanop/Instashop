//
//  PurchasingAddressViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchasingAddressViewController : UIViewController
{
    id doneButtonDelegate;
    
    UITextField *nameTextField;
    UITextField *addressTextField;
    UITextField *cityTextField;
    UITextField *stateTextField;
    UITextField *zipTextField;
    UITextField *phoneTextField;
    
    UIButton *upsButton;
    UIButton *fedexButton;
    UIButton *doneButton;
    
    NSDictionary *sellerDictionary;
}

-(IBAction)upsButtonHit;
-(IBAction)FedexButtonHit;
-(IBAction)doneButtonHit;

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;

@property (nonatomic, retain) IBOutlet UIButton *upsButton;
@property (nonatomic, retain) IBOutlet UIButton *fedexButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) id doneButtonDelegate;

@property (nonatomic, retain) NSDictionary *sellerDictionary;

@end


