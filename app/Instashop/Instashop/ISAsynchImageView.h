//
//  ISAsynchImageView.h
//  Instashop
//
//  Created by Josh Klobe on 8/19/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISAsynchImageView : UIImageView
{
    UIActivityIndicatorView *imageLoadingIndicatorView;
}

-(void)beginAnimations;
-(void)ceaseAnimations;

@property (nonatomic, retain) UIActivityIndicatorView *imageLoadingIndicatorView;

@end
