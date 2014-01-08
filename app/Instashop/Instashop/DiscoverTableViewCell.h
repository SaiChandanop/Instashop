//
//  DiscoverTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 11/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesTableViewItem.h"

@interface DiscoverTableViewCell : UITableViewCell
{
    ImagesTableViewItem *itemOne;
    ImagesTableViewItem *itemTwo;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight;
- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray withDelegate:(id)delegate;
- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withSellerDictionaryArray:(NSArray *)sellerDictionaryArray withDelegate:(id)theDelegate;

@property (nonatomic, strong) ImagesTableViewItem *itemOne;
@property (nonatomic, strong) ImagesTableViewItem *itemTwo;



@end
