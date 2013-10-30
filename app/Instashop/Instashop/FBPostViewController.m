//
//  FBPostViewController.m
//  Instashop
//
//  Created by Josh Klobe on 10/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FBPostViewController.h"
#import "SocialManager.h"
@interface FBPostViewController ()

@end

@implementation FBPostViewController

@synthesize delegate;
@synthesize insetImageView;
@synthesize descriptionTextView;
@synthesize titleLabel;
@synthesize contentTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadWithImage:(UIImage *)theImage withDescriptionText:(NSString *)theDescriptionText withTitleText:(NSString *)theTitleText
{
    self.insetImageView.image = theImage;
    self.descriptionTextView.text = theDescriptionText;
    self.titleLabel.text = theTitleText;
    
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonHit
{
    [self.delegate fbShareCancelButtonHit:self];
}

-(IBAction)shareButtonHit
{
    [SocialManager postToFacebookWithString:self.contentTextView.text withImage:self.insetImageView.image];
    
    [self.delegate fbShareGoButtonHit:self];
}



@end
