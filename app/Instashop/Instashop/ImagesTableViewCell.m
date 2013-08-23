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

@synthesize delegate;


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


- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray
{
    int startValue = theIndexPath.row * 3;
    
    float spacer = 6.5;
    float imageWidth = self.frame.size.width / 3 - 11;
    imageWidth = 98;
    
    
    int iter = 0;
    
    self.itemOne.contentImageView.image = nil;
    self.itemTwo.contentImageView.image = nil;
    self.itemThree.contentImageView.image = nil;
    
    
    
    for (int i = startValue; i < startValue + 3 && i < [feedItemsArray count]; i++)
    {
        NSDictionary *productObjectDictionary = [feedItemsArray objectAtIndex:i];
        
        if (iter == 0 && self.itemOne == nil)
        {
                self.itemOne = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth) withProductObjectDictionary:productObjectDictionary withButtonDelegate:self.delegate];
                [self addSubview:self.itemOne];
        }
        
        else if (iter == 1 && self.itemTwo == nil)
        {
                self.itemTwo = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth) withProductObjectDictionary:productObjectDictionary withButtonDelegate:self.delegate];
                [self addSubview:self.itemTwo];
        }
        
        else if (iter == 2 && self.itemThree == nil)
        {
            self.itemThree = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth) withProductObjectDictionary:productObjectDictionary withButtonDelegate:self.delegate];
            [self addSubview:self.itemThree];
        }
        
        iter++;
        
        [self.itemOne loadImages];
        [self.itemTwo loadImages];
        [self.itemThree loadImages];
        
        
        [self bringSubviewToFront:self.itemOne];
        [self bringSubviewToFront:self.itemTwo];
        [self bringSubviewToFront:self.itemThree];

    }
    
}



@end
