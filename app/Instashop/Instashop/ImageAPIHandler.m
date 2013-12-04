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


+(void)makeSynchImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView
{
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
        sharedImageAPIHandler.mediaCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
  
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


+(void)makeImageRequestWithDelegate:(id)theDelegate withInstagramMediaURLString:(NSString *)instagramMediaURLString withImageView:(UIImageView *)referenceImageView
{
    if (sharedImageAPIHandler == nil)
    {
        sharedImageAPIHandler = [[ImageAPIHandler alloc] init];
        sharedImageAPIHandler.mediaCache = [[NSMutableDictionary alloc] initWithCapacity:0];
    }

/*    if ([sharedImageAPIHandler.mediaCache objectForKey:instagramMediaURLString])
    {
        
        referenceImageView.image = [sharedImageAPIHandler.mediaCache objectForKey:instagramMediaURLString];
        referenceImageView.alpha = 1;
        
        if ([referenceImageView isKindOfClass:[ISAsynchImageView class]])
            [(ISAsynchImageView *)referenceImageView ceaseAnimations];
        
    }
*/
    
    ImageAPIHandler *handler = [[ImageAPIHandler alloc] init];
    handler.delegate = theDelegate;
    handler.contextObject = instagramMediaURLString;
    handler.receivedData = [[NSMutableData alloc] init];
    handler.theImageView = referenceImageView;
    handler.theWebRequest = [SMWebRequest requestWithURLRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:instagramMediaURLString]] delegate:handler context:NULL];
    [handler.theWebRequest addTarget:handler action:@selector(instagramImageReqeustFinsihed:) forRequestEvents:SMWebRequestEventComplete];
    [handler.theWebRequest start];
    
}

- (void) instagramImageReqeustFinsihed:(id)obj
{
    
    
    UIImage *responseImage = [UIImage imageWithData:self.responseData];
    [sharedImageAPIHandler.mediaCache setObject:responseImage forKey:self.contextObject];
    
    if (self.theImageView != nil)
    {
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
         [self.delegate imageReturnedWithURL:self.contextObject withImage:responseImage];
}





- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
 //   NSLog(@"receivedData.length: %d", [self.receivedData length]);
    UIImage *responseImage = [UIImage imageWithData:self.receivedData];
    
//    NSLog(@"connectionDidFinishLoading, responseImage: %@", responseImage);
//    NSString *key =[[[connection originalRequest] URL] absoluteString];
    if (responseImage != nil)
    {
//        [sharedImageAPIHandler.mediaCache setObject:responseImage forKey:key];
        self.theImageView.image = responseImage;
        self.theImageView.alpha = 1;
        
        if ([self.delegate respondsToSelector:@selector(imageRequestFinished:)])
        {
            [self.delegate imageRequestFinished:self.theImageView];
        }
        else if ([self.theImageView isKindOfClass:[ISAsynchImageView class]])
        {
            [(ISAsynchImageView *)self.theImageView ceaseAnimations];
        }
        else
        {
            [self.delegate imageReturnedWithURL:self.contextObject withImage:responseImage];
        }
        
        
    }
    else
    {
        self.theImageView.image = [UIImage imageNamed:@"iTunesArtwork.png"];        
    }
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
