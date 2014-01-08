//
//  AmberViewController.h
//  Instashop
//
//  Created by Josh Klobe on 10/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmberViewController : UIViewController
{
    UIWebView *amberWebView;
    UIView *loadingView;
    NSString *referenceURLString;
    NSString *viglinkString;
    UIImage *referenceImage;
}
-(void)run;

@property (nonatomic, strong) IBOutlet UIWebView *amberWebView;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) NSString *referenceURLString;
@property (nonatomic, strong) NSString *viglinkString;
@property (nonatomic, strong) UIImage *referenceImage;
@end
