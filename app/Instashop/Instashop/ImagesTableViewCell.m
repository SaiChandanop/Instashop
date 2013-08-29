//
//  ImagesTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImagesTableViewCell.h"
#import "ImageAPIHandler.h"
#import "CellSelectionOccuredProtocol.h"
@implementation ImagesTableViewCell



@synthesize itemOne;
@synthesize itemTwo;
@synthesize itemThree;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray withDelegate:(id)theDelegate
{
    int startValue = theIndexPath.row * 3;

    float imageWidth = 106;
    
    if (self.itemOne == nil)
    {
        self.itemOne = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(1, 0, imageWidth, imageWidth + 2)];
        [self addSubview:self.itemOne];
    }
    
    if (self.itemTwo == nil)
    {
        self.itemTwo = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(107, 0, imageWidth, imageWidth + 2)];
        [self addSubview:self.itemTwo];
    }
    
    if (self.itemThree == nil)
    {
        self.itemThree = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(213, 0, imageWidth, imageWidth + 2)];
        [self addSubview:self.itemThree];
    }

    
    self.itemOne.delegate = theDelegate;
    self.itemTwo.delegate = theDelegate;
    self.itemThree.delegate = theDelegate;
        
    
    [self.itemOne cleanContent];
    [self.itemTwo cleanContent];
    [self.itemThree cleanContent];

    
    for (int i = 0; i < 3; i++)
    {
        int indexPosition = startValue + i;
        
        if (indexPosition < [feedItemsArray count])
        {
            NSDictionary *productObjectDictionary = [feedItemsArray objectAtIndex:indexPosition];
            switch (i) {
                case 0:
                    [self.itemOne loadContentWithDictionary:productObjectDictionary];
                    break;
                case 1:
                    [self.itemTwo loadContentWithDictionary:productObjectDictionary];
                    break;
                case 2:
                    [self.itemThree loadContentWithDictionary:productObjectDictionary];
                    break;
                    
                default:
                    break;
            }
        }

    }

    
    [self bringSubviewToFront:self.itemOne];
    [self bringSubviewToFront:self.itemTwo];
    [self bringSubviewToFront:self.itemThree];

    
}



@end
