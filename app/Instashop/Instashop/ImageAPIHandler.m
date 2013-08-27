//
//  ImageAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImageAPIHandler.h"
#import "ISAsynchImageView.h"

@implementation ImageAPIHandler

@synthesize mediaCache, theImageView;
@synthesize receivedData;

static ImageAPIHandler *sharedImageAPIHandler;

+(void)makeImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView
{
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
        sharedImageAPIHandler.mediaCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    if ([sharedImageAPIHandler.mediaCache objectForKey:instagramMediaURLString])
    {
        
        referenceImageView.image = [sharedImageAPIHandler.mediaCache objectForKey:instagramMediaURLString];
        referenceImageView.alpha = 1;
        
        if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
            [(ISAsynchImageView *)referenceImageView ceaseAnimations];
        
    }
    else
    {
        ImageAPIHandler *handler = [[ImageAPIHandler alloc] init];
        handler.delegate = theDelegate;
        handler.theImageView = referenceImageView;
        handler.receivedData = [[NSMutableData alloc] init];
        
        NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:instagramMediaURLString]];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:URLRequest
                                       delegate:handler
                                       startImmediately:NO];
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSRunLoopCommonModes];
        [connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
 
  //   NSLog(@"%@ received data!", self);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
 //   NSLog(@"receivedData.length: %d", [self.receivedData length]);
    UIImage *responseImage = [UIImage imageWithData:self.receivedData];
    
    NSString *key =[[[connection originalRequest] URL] absoluteString];
    if (responseImage != nil)
    {
        [sharedImageAPIHandler.mediaCache setObject:responseImage forKey:key];
        self.theImageView.image = responseImage;
        self.theImageView.alpha = 1;
        
        if ([self.delegate respondsToSelector:@selector(imageRequestFinished:)])
        {
            [self.delegate imageRequestFinished:self.theImageView];
        }
        
        if ([self.theImageView isKindOfClass:[ISAsynchImageView class]])
        {
            [(ISAsynchImageView *)self.theImageView ceaseAnimations];
        }
    }
    else
    {
      //  NSLog(@"image request fail at key: %@", key);
        
    }
}
+(void)makeProfileImageRequestWithReferenceImageView:(UIImageView *)referenceImageView withInstagramID:(NSString *)instagramID
{
    NSString *urlString = [NSString stringWithFormat:@"http://instashop.com/upload/%@.jpeg", instagramID];
    
    NSLog(@"makeProfileImageRequestWithReferenceImageView, urlString: %@", urlString);
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    ImageAPIHandler *imageAPIHandler = [[ImageAPIHandler alloc] init];
    imageAPIHandler.theImageView = referenceImageView;
    imageAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:imageAPIHandler context:NULL];
    [imageAPIHandler.theWebRequest addTarget:imageAPIHandler action:@selector(imageRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [imageAPIHandler.theWebRequest start];
    
}

-(void)imageRequestFinished:(id)obj
{
    UIImage *responseImage = [UIImage imageWithData:self.responseData];
    [sharedImageAPIHandler.mediaCache setObject:responseImage forKey:[self.theWebRequest.request.URL absoluteString]];
    self.theImageView.image = responseImage;
    self.theImageView.alpha = 1;
    
    if ([self.delegate respondsToSelector:@selector(imageRequestFinished:)])
    {
        [self.delegate imageRequestFinished:self.theImageView];
    }
    
    if ([self.theImageView isKindOfClass:[ISAsynchImageView class]])
    {
        [(ISAsynchImageView *)self.theImageView ceaseAnimations];
    }
}



@end
