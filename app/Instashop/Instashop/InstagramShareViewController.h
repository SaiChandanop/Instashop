//
//  InstagramShareViewController.h
//  Instashop
//
//  Created by Joel Barron on 1/8/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramShareViewController : UIViewController <UIScrollViewDelegate>
{
    NSMutableArray *imageViewsArray;
    int currentSelectedIndex;
}

-(UIImage *)getSelectedImage;

@property (nonatomic, retain) NSMutableArray *imageViewsArray;
@property (nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, assign) int currentSelectedIndex;

@end
