//
//  BuyViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "BuyViewController.h"

@interface BuyViewController ()

@end

@implementation BuyViewController

@synthesize contentScrollView;

@synthesize creditCardTextField;
@synthesize monthExpirationField;
@synthesize yearExpirationField;
@synthesize ccvTextField;

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
    
    self.contentScrollView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.contentScrollView];
}



-(IBAction)backButtonHit
{
    
}

-(IBAction)buyButtonHit
{
    
}


@end
