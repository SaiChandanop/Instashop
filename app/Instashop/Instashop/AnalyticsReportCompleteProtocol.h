//
//  AnalyticsReportCompleteProtocol.h
//  Instashop
//
//  Created by Josh Klobe on 3/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnalyticsReportCompleteProtocol <NSObject>


-(void)reportDidCompleteWithDictionary:(NSDictionary *)theDict;
@end
