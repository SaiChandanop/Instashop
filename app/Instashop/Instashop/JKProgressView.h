//
//  JKProgressView.h
//  Instashop
//
//  Created by Josh Klobe on 1/20/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKProgressView : UIView
{
    UIActivityIndicatorView *theIndicatorView;
    UILabel *theLabel;
}

+(JKProgressView *)presentProgressViewInView:(UIView *)referenceView withText:(NSString *)theText;
-(void)hideProgressView;

@property (nonatomic, retain) UIActivityIndicatorView *theIndicatorView;
@property (nonatomic, retain) UILabel *theLabel;

@end
