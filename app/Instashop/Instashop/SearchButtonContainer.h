//
//  SearchButtonContainer.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchSiloViewController;

#define SEARCH_BUTTON_TYPE_CATEGORIES 0
#define SEARCH_BUTTON_TYPE_FREE 1

@interface SearchButtonContainer : UIButton
{
    NSString *searchTerm;
    int type;
}

-(void) loadWithSearchTerm:(NSString *)theSearchTerm withClickDelegate:(SearchSiloViewController *)searchSiloViewController;

@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, assign) int type;
@end
