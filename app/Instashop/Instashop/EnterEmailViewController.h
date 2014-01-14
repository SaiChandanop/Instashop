//
//  EnterEmailViewController.h
//  Instashop
//
//  Created by Susan Yee on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesViewController.h"

@class FirstTimeUserViewController;

@interface EnterEmailViewController : UIViewController <UITextFieldDelegate>
{
    UIButton *nextButton;
    CategoriesViewController *categoriesViewController;
    UILabel *categoriesLabel;
    UIButton *tosButton;
}

-(IBAction)tosLinkButtonHit;
-(IBAction)categoriesButtonHit;
-(IBAction)tosButtonHit;

@property (nonatomic, strong) FirstTimeUserViewController *firstTimeUserViewController;
@property (nonatomic, strong) IBOutlet UIView *enterEmailView;
@property (nonatomic, strong) IBOutlet UITextField *enterEmailTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UILabel *categoriesLabel;
@property (nonatomic, strong) IBOutlet UIButton *tosButton;
@property (nonatomic, strong) CategoriesViewController *categoriesViewController;

@end
