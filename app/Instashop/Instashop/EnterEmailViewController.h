//
//  EnterEmailViewController.h
//  Instashop
//
//  Created by Susan Yee on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriesViewController.h"
#import "InterestsViewController.h"
@class FirstTimeUserViewController;

@interface EnterEmailViewController : UIViewController <UITextFieldDelegate>
{
    InterestsViewController *interestsViewController;
    UILabel *categoriesLabel;
    UIButton *tosButton;
}

-(IBAction)tosLinkButtonHit;
-(IBAction)categoriesButtonHit;
-(IBAction)tosButtonHit;
-(void)categorySelectionCompleteWithString:(NSString *)theCategory;


@property (nonatomic, strong) InterestsViewController *interestsViewController;
@property (nonatomic, strong) FirstTimeUserViewController *firstTimeUserViewController;
@property (nonatomic, strong) IBOutlet UIView *enterEmailView;
@property (nonatomic, strong) IBOutlet UITextField *enterEmailTextField;
@property (nonatomic, strong) IBOutlet UILabel *categoriesLabel;
@property (nonatomic, strong) IBOutlet UIButton *tosButton;

@end
