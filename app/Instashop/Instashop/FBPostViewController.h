//
//  FBPostViewController.h
//  Instashop
//
//  Created by Josh Klobe on 10/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBPostViewController : UIViewController
{
    id delegate;
    UIImageView *insetImageView;
    UITextView *descriptionTextView;
    UILabel *titleLabel;
    UITextView *contentTextView;
}

- (void) loadWithImage:(UIImage *)theImage withDescriptionText:(NSString *)theDescriptionText withTitleText:(NSString *)theTitleText;
-(IBAction)cancelButtonHit;
-(IBAction)shareButtonHit;

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) IBOutlet UIImageView *insetImageView;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *contentTextView;
@end
