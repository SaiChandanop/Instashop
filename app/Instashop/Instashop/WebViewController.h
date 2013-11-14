//
//  WebViewController.h
//  Instashop
//
//  Created by A50 Admin on 11/13/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppRootViewController;

@interface WebViewController : UIViewController

- (id)initWithWebView:(NSString *) websiteName title:(NSString *) titleName;

@property (nonatomic, retain) AppRootViewController *appRootViewController;
@property (nonatomic, retain) NSString *titleName;


@end
