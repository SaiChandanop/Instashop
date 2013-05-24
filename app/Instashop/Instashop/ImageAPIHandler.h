//
//  ImageAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface ImageAPIHandler : RootAPIHandler
{
    NSMutableDictionary *mediaCache;
    UIImageView *theImageView;
}


+(void)makeImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView;


@property (nonatomic, retain) NSMutableDictionary *mediaCache;
@property (nonatomic, retain) UIImageView *theImageView;

@end
