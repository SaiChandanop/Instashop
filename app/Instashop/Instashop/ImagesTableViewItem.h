//
//  ImagesTableViewItem.h
//  Instashop
//
//  Created by Josh Klobe on 8/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ImagesTableViewItem : UIView <IGRequestDelegate>
{
    UIImageView *backgroundImageView;
    UIImageView *contentImageView;
    UIButton *coverButton;
    UIView *greyCoverView;
    
    NSDictionary *objectDictionary;
    NSDictionary *instagramObjectDictionary;
    
    NSString *imageProductURL;
    id delegate;
    
    BOOL alreadyExists;
}


- (void) cleanContent;
- (void) loadContentWithDictionary:(NSDictionary *)theDictionary;
- (void) loadContentWithInstagramDictionaryObject:(NSDictionary *)theDictionary;
- (void) imageReturnedWithURL:(NSString *)url withImage:(UIImage *)theImage;
- (void) imageReturnedWithURL:(NSString *)url withData:(NSData *)theData;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIView *greyCoverView;
@property (nonatomic, strong) NSDictionary *objectDictionary;
@property (nonatomic, strong) NSDictionary *instagramObjectDictionary;

@property (nonatomic, strong) NSString *imageProductURL;
@property (nonatomic, strong) id delegate;

@property (nonatomic, assign) BOOL alreadyExists;
@end
