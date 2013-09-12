//
//  SearchButtonContainer.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchButtonContainer.h"

@implementation SearchButtonContainer

@synthesize searchTerm;
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) loadWithSearchTerm:(NSString *)theSearchTerm withClickDelegate:(SearchSiloViewController *)searchSiloViewController
{
    self.searchTerm = theSearchTerm;
    [self setTitle:[NSString stringWithFormat:@"%@ X", self.searchTerm] forState:UIControlStateNormal];

    self.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1];
    [self addTarget:searchSiloViewController action:@selector(searchButtonContainerHit:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.textColor = [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1];
        
}



@end
