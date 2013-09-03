//
//  SearchResultTableCell.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableCell : UITableViewCell
{
    NSDictionary *searchResultObject;
}

-(void)loadWithSearchResultObject:(NSDictionary *)theSearchResultsObject;


@property (nonatomic, retain) NSDictionary *searchResultObject;
@end
