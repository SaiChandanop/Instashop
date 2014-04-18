//
//  JKProgressView.h
//  Instashop
//
//  Created by Josh Klobe on 1/20/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROGRESS_TYPE_LIKED 0
#define PROGRESS_TYPE_FOLLOWED 1

@interface JKProgressView : UIView
{
    UIActivityIndicatorView *theIndicatorView;
    UILabel *theLabel;
}

+(JKProgressView *)presentProgressViewInView:(UIView *)referenceView withText:(NSString *)theText;
+(JKProgressView *)presentProgressViewInView:(UIView *)referenceView withText:(NSString *)theText withImageType:(int)type withNegativeOffset:(float)negativeOffset;
-(void)hideProgressView;

@property (nonatomic, retain) UIActivityIndicatorView *theIndicatorView;
@property (nonatomic, retain) UILabel *theLabel;

@end
