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
}
-(void)run;

@property (nonatomic, retain) IBOutlet UIWebView *amberWebView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) NSString *referenceURLString;
@end
