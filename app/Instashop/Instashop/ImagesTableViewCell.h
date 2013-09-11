//
//  ImagesTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesTableViewItem.h"

@interface ImagesTableViewCell : UITableViewCell
{
    ImagesTableViewItem *itemOne;
    ImagesTableViewItem *itemTwo;
    ImagesTableViewItem *itemThree;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight;
- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray withDelegate:(id)delegate;
- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withSellerDictionaryArray:(NSArray *)sellerDictionaryArray withDelegate:(id)theDelegate;



@property (nonatomic, retain) ImagesTableViewItem *itemOne;
@property (nonatomic, retain) ImagesTableViewItem *itemTwo;
@property (nonatomic, retain) ImagesTableViewItem *itemThree;






@end
