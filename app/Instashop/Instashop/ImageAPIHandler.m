//
//  ImageAPIHandler.m
//  Instashop
//  APIHandler to request sync or async images from instagram and shopsy, rolls items into cache manager
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImageAPIHandler.h"
#import "ISAsynchImageView.h"
#import "ImagesTableViewCell.h"
#import "CacheManager.h"
#import "PurchasingViewController.h"
#import "ImagesTableViewItem.h"
#import "SellersTableViewCell.h"
@implementation ImageAPIHandler

@synthesize theImageView;
@synthesize receivedData;

static ImageAPIHandler *sharedImageAPIHandler;


+(void)makeSynchImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView
{
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
    }
    
    UIImage *theImage = [[CacheManager getSharedCacheManager] getImageWithURL:instagramMediaURLString];
    if (theImage != nil)
    {
        if ([theDelegate isKindOfClass:[ImagesTableViewItem class]])
            [theDelegate imageReturnedWithURL:instagramMediaURLString withImage:theImage];
        else if (referenceImageView != nil)
        {
            referenceImageView.image = theImage;
            referenceImageView.alpha = 1;
            
            if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
                [(ISAsynchImageView *)referenceImageView ceaseAnimations];
        }
        
    }
    else
    {
        
        ImageAPIHandler *handler = [[ImageAPIHandler alloc] init];
        handler.delegate = theDelegate;
        handler.contextObject = instagramMediaURLString;
        handler.receivedData = [[NSMutableData alloc] init];
        handler.theImageView = referenceImageView;
    
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:instagramMediaURLString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:handler
                                                          startImmediately:NO];
    
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [connection start];
    }
}


+(void)makeImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView
{
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
    }

    UIImage *theImage = [[CacheManager getSharedCacheManager] getImageWithURL:instagramMediaURLString];
    if (theImage != nil)
    {
        if ([theDelegate isKindOfClass:[ImagesTableViewItem class]])
             [theDelegate imageReturnedWithURL:instagramMediaURLString withImage:theImage];
        else if (referenceImageView != nil)
        {
            referenceImageView.image = theImage;
            referenceImageView.alpha = 1;
        
            if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
                [(ISAsynchImageView *)referenceImageView ceaseAnimations];
        }

    }
    else
    {
        NSLog(@"make instagram profile picture request: %@", instagramMediaURLString);
        
        ImageAPIHandler *handler = [[ImageAPIHandler alloc] init];
        handler.delegate = theDelegate;
        handler.contextObject = instagramMediaURLString;
        handler.receivedData = [[NSMutableData alloc] init];
        handler.theImageView = referenceImageView;
        handler.theWebRequest = [SMWebRequest requestWithURLRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:instagramMediaURLString]] delegate:handler context:NULL];
        [handler.theWebRequest addTarget:handler action:@selector(instagramImageReqeustFinsihed:) forRequestEvents:SMWebRequestEventComplete];
        [handler.theWebRequest start];
    }
}

- (void) instagramImageReqeustFinsihed:(id)obj
{
    NSLog(@"instagram profile picture request complete: %@", self.contextObject);
    
    UIImage *responseImage = [UIImage imageWithData:self.responseData];
    
    if (responseImage != nil && self.contextObject != nil)
    {
        [[CacheManager getSharedCacheManager] setCacheObject:responseImage withKey:self.contextObject];
    }
    if ([self.delegate isKindOfClass:[CacheManager class]])
        return;
    
    else if ([self.delegate isKindOfClass:[ImagesTableViewCell class]])
    {

        if ([self.delegate isKindOfClass:[ImagesTableViewItem class]])
            [((ImagesTableViewItem *)self.delegate) imageReturnedWithURL:self.contextObject withData:self.responseData];
    }
    else if ([self.delegate isKindOfClass:[SellersTableViewCell class]])
    {
        [((SellersTableViewCell *)self.delegate) imageReturnedWithURL:self.contextObject withImage:responseImage];
    }
    else if ([self.delegate isKindOfClass:[ImagesTableViewItem class]])
    {
//        NSLog(@"no, here");
        [((ImagesTableViewItem *)self.delegate) imageReturnedWithURL:self.contextObject withImage:responseImage];
    }
    else if (self.theImageView != nil)
    {

        self.theImageView.image = responseImage;
        self.theImageView.alpha = 1;
        
        if ([self.delegate respondsToSelector:@selector(imageRequestFinished:)])
        {
            if ([self.delegate isKindOfClass:[PurchasingViewController class]])
                [((PurchasingViewController *)self.delegate) imageRequestFinished:self.theImageView];
        }
        
        if ([self.theImageView isKindOfClass:[ISAsynchImageView class]])
        {
            [(ISAsynchImageView *)self.theImageView ceaseAnimations];
        }

    }
     else
         [self.delegate imageReturnedWithURL:self.contextObject withData:self.responseData];
    
}





- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"connectionDidFinishLoading");

        UIImage *theImage = [UIImage imageWithData:self.receivedData];
    
    
    
        if (theImage != nil && self.contextObject != nil)
        {
            [[CacheManager getSharedCacheManager] setCacheObject:theImage withKey:self.contextObject];
        }
    
        if (self.theImageView != nil && theImage != nil)
            self.theImageView.image = theImage;
    
        self.theImageView.alpha = 1;
        
        if ([self.delegate respondsToSelector:@selector(imageRequestFinished:)])
            [self.delegate imageRequestFinished:self.theImageView];
        else if ([self.theImageView isKindOfClass:[ISAsynchImageView class]])
            [(ISAsynchImageView *)self.theImageView ceaseAnimations];
        else
            [self.delegate imageReturnedWithURL:self.contextObject withData:self.receivedData];
    
    self.contextObject;
//    [self.theImageView release];
    [self.receivedData setLength:0];
    self.receivedData;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
    
    //   NSLog(@"%@ received data!", self);
}



- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];
    
    // Look up the cache policy used in our request
    if([connection currentRequest].cachePolicy == NSURLRequestUseProtocolCachePolicy) {
        NSDictionary *headers = [httpResponse allHeaderFields];
        NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
        NSString *expires = [headers valueForKey:@"Expires"];
        if((cacheControl == nil) && (expires == nil)) {
            NSLog(@"server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
            return nil; // don't cache this
        }
    }
    
    return cachedResponse;
    
}

+(void)makeProfileImageRequestWithReferenceImageView:(UIImageView *)referenceImageView withInstagramID:(NSString *)instagramID
{
    NSString *urlString = [NSString stringWithFormat:@"%@/upload/%@.jpeg", [Utils getRootURI], instagramID];
    
    NSLog(@"Make shopsy profile picture request: %@", urlString);
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
    }
    
    UIImage *theImage = [[CacheManager getSharedCacheManager] getImageWithURL:urlString];
    if (theImage != nil)
    {

        referenceImageView.image = theImage;
            referenceImageView.alpha = 1;
            
            if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
                [(ISAsynchImageView *)referenceImageView ceaseAnimations];
        
    }
    else
    {
        ImageAPIHandler *handler = [[ImageAPIHandler alloc] init];
        handler.contextObject = urlString;
        handler.receivedData = [[NSMutableData alloc] init];
        handler.theImageView = referenceImageView;
        handler.theWebRequest = [SMWebRequest requestWithURLRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:handler context:NULL];
        [handler.theWebRequest addTarget:handler action:@selector(makeProfileImageRequestWithReferenceImageViewFinished:) forRequestEvents:SMWebRequestEventComplete];
        [handler.theWebRequest start];
    }
    
}

- (void) makeProfileImageRequestWithReferenceImageViewFinished:(id)obj
{
 
    
    UIImage *responseImage = [UIImage imageWithData:self.responseData];
    NSLog(@"shopsy profile image request finished: %@", self.contextObject);
    
    
    if (responseImage != nil && self.contextObject != nil)
    {
        [[CacheManager getSharedCacheManager] setCacheObject:responseImage withKey:self.contextObject];
    }
    
    if (responseImage != nil)
        self.theImageView.image = responseImage;
    
    
    
}




+(void)makePbrofileImageRequestWithReferenceImageView:(UIImageView *)referenceImageView withInstagramID:(NSString *)instagramID
{
    NSString *urlString = [NSString stringWithFormat:@"http://instashop.com/upload/%@.jpeg", instagramID];
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    ImageAPIHandler *imageAPIHandler = [[ImageAPIHandler alloc] init];
    imageAPIHandler.theImageView = referenceImageView;
    imageAPIHandler.receivedData = [[NSMutableData alloc] init];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:URLRequest
                                   delegate:imageAPIHandler
                                   startImmediately:NO];
    
//    connection.currentRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    connection.ca
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSRunLoopCommonModes];
    [connection start];

    
    
    
    
}



@end
