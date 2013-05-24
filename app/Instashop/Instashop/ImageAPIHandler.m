//
//  ImageAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImageAPIHandler.h"

@implementation ImageAPIHandler

@synthesize mediaCache, theImageView;

static ImageAPIHandler *sharedImageAPIHandler;

+(void)makeImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView
{
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
        sharedImageAPIHandler.mediaCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    if ([sharedImageAPIHandler.mediaCache objectForKey:instagramMediaURLString])
        referenceImageView.image = [sharedImageAPIHandler.mediaCache objectForKey:instagramMediaURLString];
    else
    {
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:instagramMediaURLString]];
        
        ImageAPIHandler *imageAPIHandler = [[ImageAPIHandler alloc] init];
        imageAPIHandler.theImageView = referenceImageView;
        imageAPIHandler.delegate = theDelegate;
        imageAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:imageAPIHandler context:NULL];
        [imageAPIHandler.theWebRequest addTarget:imageAPIHandler action:@selector(imageRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
        [imageAPIHandler.theWebRequest start];
    }
    
}


-(void)imageRequestFinished:(id)obj
{
     UIImage *responseImage = [UIImage imageWithData:self.responseData];
    [sharedImageAPIHandler.mediaCache setObject:responseImage forKey:[self.theWebRequest.request.URL absoluteString]];
    self.theImageView.image = responseImage;
    self.theImageView.alpha = 1;
}
@end
