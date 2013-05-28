//
//  RootAPIHandler.h
//  HomeTalk
//
//  Created by Josh Klobe on 9/25/12.
//  Copyright (c) 2012 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMWebRequest.h"
#import "Utils.h"

#define ROOT_URI @"http://www.instashopdev.com.php54-1.ord1-1.websitetestlink.com"
@interface RootAPIHandler : NSObject <SMWebRequestDelegate>
{

    SMWebRequest *theWebRequest;
    id delegate;
    NSData *responseData;
    NSURLResponse *response;
    
    id contextObject;
    

}

@property (nonatomic, retain) SMWebRequest *theWebRequest;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSURLResponse *response;

@property (nonatomic, retain) id contextObject;
@end
