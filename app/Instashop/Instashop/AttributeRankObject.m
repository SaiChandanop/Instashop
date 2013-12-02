//
//  AttributeRankObject.m
//  Instashop
//
//  Created by Josh Klobe on 12/2/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AttributeRankObject.h"

@implementation AttributeRankObject

@synthesize attributeString;
@synthesize rank;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Rank object[%@]: %d", self.attributeString, self.rank];
}

@end
