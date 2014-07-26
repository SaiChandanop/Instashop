//
//  SellersAPIHandler.m
//  Instashop
//  APIHandler for seller CRUD requests from api to server
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SellersAPIHandler.h"
#import "AppDelegate.h"
#import "InstagramUserObject.h"
#import "SellerExistsResponderProtocol.h"
#import "CreateSellerOccuredProtocol.h"
#import "SellersRequestFinishedProtocol.h"
#import "SellerDetailResponseProtocol.h"

@implementation SellersAPIHandler

+(void)makeCheckIfSellerExistsCallWithDelegate:(id)delegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"sellerfunctions/create_seller.php?action=checkSeller"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];    
    [thePostString appendString:[NSString stringWithFormat:@"userID=%@", [InstagramUserObject getStoredUserObject].userID]];
    [thePostString appendString:[NSString stringWithFormat:@"&action=%@", @"checkSeller"]];
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = delegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(checkSellerExistsCallFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)checkSellerExistsCallFinished:(id)obj
{
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([responseDictionary isKindOfClass:[NSDictionary class]])
    if ([responseDictionary objectForKey:@"zencart_id"] != nil)
    {
        InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
        theUserObject.zencartID = [responseDictionary objectForKey:@"zencart_id"];
    
        [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];
    }
    
    
    if ([self.delegate conformsToProtocol:@protocol(SellerExistsResponderProtocol)])
        [(id<SellerExistsResponderProtocol>)self.delegate sellerExistsCallReturned];

    
}



+(void)updateSellerPushIDWithPushID:(NSString *)pushID withInstagramID:(NSString *)instagramID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"sellerfunctions/create_seller.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];
    [thePostString appendString:[NSString stringWithFormat:@"action=%@", @"update_push_id"]];
    [thePostString appendString:[NSString stringWithFormat:@"&instagram_id=%@", [InstagramUserObject getStoredUserObject].userID]];
    [thePostString appendString:[NSString stringWithFormat:@"&push_id=%@", pushID]];
    
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(updateSellerPushIDFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)updateSellerPushIDFinished:(id)obj
{
    
}






+(void)makeCreateSellerRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject withSellerAddressDictionary:(NSDictionary *)addressDictionary
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"sellerfunctions/create_seller.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];
    
    
    [thePostString appendString:[instagramUserObject userObjectAsPostString]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pushDeviceTokenString != nil)
        [thePostString appendString:[NSString stringWithFormat:@"&push_id=%@", appDelegate.pushDeviceTokenString]];
    
    for (id key in addressDictionary)
        [thePostString appendString:[NSString stringWithFormat:@"&%@=%@", key, [addressDictionary objectForKey:key]]];
    
    [thePostString appendString:[NSString stringWithFormat:@"&%@=%@", @"instagram_username", instagramUserObject.username]];
    
    
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(userCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}


-(void)userCreateRequestFinished:(id)obj
{
    
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([self.delegate conformsToProtocol:@protocol(CreateSellerOccuredProtocol)])
        [(id<CreateSellerOccuredProtocol>)self.delegate userDidCreateSellerWithResponseDictionary:responseDictionary];

}


+(void)makeGetSellersRequestWithDelegate:(id)theDelegate withSellerInstagramID:(NSString *)sellerInstagramID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", [Utils getRootURI], @"sellerfunctions/get_sellers.php?seller_instagram_id=", sellerInstagramID];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getSellersRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
  
}


-(void)getSellersRequestFinished:(id)obj
{
//    NSString* responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
    if ([self.delegate conformsToProtocol:@protocol(SellersRequestFinishedProtocol)])
        [(id<SellersRequestFinishedProtocol>)self.delegate sellersRequestFinishedWithResponseObject:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil]];
    
}

+(void)uploadProfileImage:(UIImage *)image withDelegate:(id)theDelegate
{
    NSLog(@"uploadProfileImage, image: %@, withDelegate: %@", image, theDelegate);
 
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", [Utils getRootURI], @"profile_image_upload.php", @""];
    NSURL *url = [NSURL URLWithString:urlRequestString];
    // encode the image as JPEG
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    
    // set up the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    
    // create a boundary to delineate the file
    NSString *boundary = @"14737809831466499882746641449";
    // tell the server what to expect
    NSString *contentType =
    [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // make a buffer for the post body
    NSMutableData *body = [NSMutableData data];
    
    // add a boundary to show where the title starts
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary]
                      dataUsingEncoding:NSASCIIStringEncoding]];
    
    // add the title
    [body appendData:[
                      @"Content-Disposition: form-data; name=\"title\"\r\n\r\n"
                      dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[InstagramUserObject getStoredUserObject].userID  //[@"JOSH TITLE"
                      dataUsingEncoding:NSASCIIStringEncoding]];
    
    // add a boundary to show where the file starts
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary]
                      dataUsingEncoding:NSASCIIStringEncoding]];
    
    // add a form field
    [body appendData:[
                      @"Content-Disposition: form-data; name=\"picture\"; filename=\"image.jpeg\"\r\n"
                      dataUsingEncoding:NSASCIIStringEncoding]];
    
    // tell the server to expect some binary
    [body appendData:[
                      @"Content-Type: application/octet-stream\r\n"
                      dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[
                      @"Content-Transfer-Encoding: binary\r\n"
                      dataUsingEncoding:NSASCIIStringEncoding]];
    [body appendData:[[NSString stringWithFormat:
                       @"Content-Length: %i\r\n\r\n", imageData.length]
                      dataUsingEncoding:NSASCIIStringEncoding]];
    
    // add the payload
    [body appendData:[NSData dataWithData:imageData]];
    
    // tell the server the payload has ended
    [body appendData:
     [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary]
      dataUsingEncoding:NSASCIIStringEncoding]];
    
    // add the POST data as the request body
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"%@", returnString);
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:request delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(uploadImageRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)uploadImageRequestFinished:(id)object
{
    
    NSLog(@"uploadImageRequestFinished");
    
//    [self.delegate loadTheProfileImageViewWithID:[InstagramUserObject getStoredUserObject].userID];
    
}


+(void)getSellerDetailsWithInstagramID:(NSString *)instagramID withDelegate:(id)theDelegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"sellerfunctions/sellerManager.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];
    [thePostString appendString:[NSString stringWithFormat:@"instagramID=%@", instagramID]];
    [thePostString appendString:[NSString stringWithFormat:@"&action=%@", @"getSellerDetails"]];
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getSellerDetailsFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)getSellerDetailsFinished:(id)object
{
    //NSString* responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
//    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];

    if ([self.delegate conformsToProtocol:@protocol(SellerDetailResponseProtocol)])
        [(id<SellerDetailResponseProtocol>)self.delegate sellerDetailsResopnseDidOccurWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil]];

    
    
}

+(void)makeGetAllSellersRequestWithDelegate:(id)theDelegate
{
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"sellerfunctions/get_sellers.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getSellersRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

+(void)updateSellerDescriptionWithDelegate:(id)theDelegate InstagramID:(NSString *)instagramID withDescription:(NSString *)theDescription
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"sellerfunctions/sellerManager.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
//    NSLog(@"urlRequestString: %@", urlRequestString);
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];
    [thePostString appendString:[NSString stringWithFormat:@"action=%@", @"updateSellerDescription"]];
    [thePostString appendString:[NSString stringWithFormat:@"&instagramID=%@", instagramID]];
    [thePostString appendString:[NSString stringWithFormat:@"&description=%@", theDescription]];
    
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];

    NSLog(@"thePostString: %@", thePostString);
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(updateSellerDescriptionFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
}

-(void)updateSellerDescriptionFinished:(id)object
{
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"getSellerDetailsFinished: %@", responseString);

}


@end
