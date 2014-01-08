//
//  SellersTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"

@interface SellersTableViewCell : UITableViewCell <IGRequestDelegate>
{
    UIImageView *sellerImageView;
    UILabel *sellerTextLabel;
}

- (void) loadWithDictionary:(NSDictionary *)theDictionary;

@property (nonatomic, strong) UIImageView *sellerImageView;
@property (nonatomic, strong) UILabel *sellerTextLabel;

@end
