//
//  EnterEmailViewController.h
//  Instashop
//
//  Created by Susan Yee on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstTimeUserViewController;

@interface EnterEmailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) FirstTimeUserViewController *firstTimeUserViewController;
@property (nonatomic, strong) IBOutlet UIView *enterEmailView;
@property (nonatomic, strong) IBOutlet UITextField *enterEmailTextField;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;

@end
