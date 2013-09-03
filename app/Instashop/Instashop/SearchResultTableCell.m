//
//  SearchResultTableCell.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//


#import "SearchResultTableCell.h"
#import "SearchViewController.h"
@implementation SearchResultTableCell

@synthesize searchResultObject;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)loadWithSearchResultObject:(NSDictionary *)theSearchResultsObject
{
    self.searchResultObject = [[NSDictionary alloc] initWithDictionary:theSearchResultsObject];
    
    NSLog(@"load: %@", theSearchResultsObject);
    NSLog(@"theSearchResultsObject.type: %@", [[theSearchResultsObject objectForKey:@"type"] class]);
    
    switch ([[self.searchResultObject objectForKey:@"type"] integerValue]) {
        case SEARCH_RESULT_TYPE_PRODUCT:
            self.textLabel.text = [NSString stringWithFormat:@"product: %@", [self.searchResultObject objectForKey:@"id"]];
            break;
            
        default:
            break;
    }
 //   self.textLabel.text = [NSString s]
}


@end
