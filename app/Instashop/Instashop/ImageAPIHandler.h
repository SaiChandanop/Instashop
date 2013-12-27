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
    
    UIImageView *theImageView;
    
    NSMutableData *receivedData;
}

+(void)makeSynchImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView;
+(void)makeImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView;
+(void)makeProfileImageRequestWithReferenceImageView:(UIImageView *)referenceImageView withInstagramID:(NSString *)instagramID;



@property (nonatomic, retain) UIImageView *theImageView;

@property (nonatomic, retain) NSMutableData *receivedData;
@end
