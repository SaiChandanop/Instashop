//
//  ImagesTableViewItem.h
//  Instashop
//
//  Created by Josh Klobe on 8/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesTableViewItem : UIView
{
    UIImageView *backgroundImageView;
    UIImageView *contentImageView;
    UIButton *coverButton;
    
    NSDictionary *objectDictionary;
    
    NSString *imageProductURL;
    id delegate;
}


- (void) cleanContent;
- (void) loadContentWithDictionary:(NSDictionary *)theDictionary;


@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImageView *contentImageView;
@property (nonatomic, retain) UIButton *coverButton;

@property (nonatomic, retain) NSDictionary *objectDictionary;

@property (nonatomic, retain) NSString *imageProductURL;
@property (nonatomic, retain) id delegate;
@end
