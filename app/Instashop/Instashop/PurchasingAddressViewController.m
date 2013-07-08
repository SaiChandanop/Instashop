//
//  PurchasingAddressViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchasingAddressViewController.h"

@interface PurchasingAddressViewController ()

@end

@implementation PurchasingAddressViewController

@synthesize doneButtonDelegate;

@synthesize nameTextField;
@synthesize addressTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneTextField;


@synthesize upsButton;
@synthesize fedexButton;
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)upsButtonHit
{
    
}

-(IBAction)FedexButtonHit
{
    
}

-(IBAction)doneButtonHit
{
    [self.doneButtonDelegate doneButtonHitWithAddressVC:self];
}

@end
