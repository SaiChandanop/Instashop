//
//  ISRowContainerView.h
//  Instashop
//
//  Created by Josh Klobe on 8/21/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISRowContainerView : UIView
{
    UIImageView *backgroundImageView;
    UIImageView *separatorImageView;
    
}
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *separatorImageView;
@end
