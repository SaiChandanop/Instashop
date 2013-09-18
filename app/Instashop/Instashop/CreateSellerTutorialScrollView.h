//
//  CreateSellerTutorialScrollView.h
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateSellerTutorialDelegate <NSObject>

- (void) signUp;

@end

@interface CreateSellerTutorialScrollView : UIScrollView

@end
