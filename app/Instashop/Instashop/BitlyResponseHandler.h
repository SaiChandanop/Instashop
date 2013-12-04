//
//  BitlyResponseHandler.h
//  Instashop
//
//  Created by Josh Klobe on 11/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BitlyResponseHandler <NSObject>

-(void)bitlyCallDidRespondWIthShortURLString:(NSString *)shortURLString;
-(void)bitlyExpandCallDidRespondWithURLString:(NSString *)urlString;

@end
