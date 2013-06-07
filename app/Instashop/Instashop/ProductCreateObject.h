//
//  ProductCreateObject.h
//  Instashop
//
//  Created by Josh Klobe on 6/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCreateObject : NSObject
{
    NSString *caption;
    NSString *description;
    NSString *retailValue;
    NSString *shippingWeight;
    NSString *price;
    NSString *category;
    NSString *categoryAttribute;
    NSString *quantity;
    
    NSString *instagramPictureURLString;
    NSDictionary *instragramMediaInfoDictionary;
}

@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *retailValue;
@property (nonatomic, retain) NSString *shippingWeight;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *categoryAttribute;
@property (nonatomic, retain) NSString *quantity;

@property (nonatomic, retain) NSString *instagramPictureURLString;
@property (nonatomic, retain) NSDictionary *instragramMediaInfoDictionary;

@end
