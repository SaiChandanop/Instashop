//
//  SearchButtonContainer.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchButtonContainer : UIButton
{
    NSString *searchTerm;
}

@property (nonatomic, retain) NSString *searchTerm;
@end
