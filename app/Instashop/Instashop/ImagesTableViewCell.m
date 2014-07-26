//
//  ImagesTableViewCell.m
//  Instashop
//  Table Cell used in any 3-column product presentation view
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
@synthesize stifleFlashRefresh;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void) handleLayoutWithDelegate:(id)theDelegate
{
    float imageWidth = self.frame.size.width/3;
    
    if (self.itemOne == nil)
    {
        self.itemOne = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        self.itemOne.stifleFlashRefresh = self.stifleFlashRefresh;
        [self addSubview:self.itemOne];
    }
    
    if (self.itemTwo == nil)
    {
        self.itemTwo = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(self.itemOne.frame.size.width, 0, imageWidth, imageWidth)];
        self.itemTwo.stifleFlashRefresh = self.stifleFlashRefresh;
        [self addSubview:self.itemTwo];
    }
    
    if (self.itemThree == nil)
    {
        self.itemThree = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(self.itemTwo.frame.origin.x + self.itemTwo.frame.size.width, 0, imageWidth, imageWidth)];
        self.itemThree.stifleFlashRefresh = self.stifleFlashRefresh;
        [self addSubview:self.itemThree];
    }
    
    
    self.itemOne.delegate = theDelegate;
    self.itemTwo.delegate = theDelegate;
    self.itemThree.delegate = theDelegate;
    
    
    [self.itemOne cleanContent];
    [self.itemTwo cleanContent];
    [self.itemThree cleanContent];
    
}


- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withSellerDictionaryArray:(NSArray *)sellerDictionaryArray withDelegate:(id)theDelegate
{
    NSLog(@"loadWithIndexPath withSellerDictionaryArray");
    [self handleLayoutWithDelegate:theDelegate];
    int startValue = theIndexPath.row * 3;
    
    for (int i = 0; i < 3; i++)
    {
        int indexPosition = startValue + i;
        
        if (indexPosition < [sellerDictionaryArray count])
        {
            NSDictionary *productObjectDictionary = [sellerDictionaryArray objectAtIndex:indexPosition];
            switch (i) {
                case 0:
                    [self.itemOne loadContentWithInstagramDictionaryObject:productObjectDictionary];
                    break;
                case 1:
                    [self.itemTwo loadContentWithInstagramDictionaryObject:productObjectDictionary];
                    break;
                case 2:
                    [self.itemThree loadContentWithInstagramDictionaryObject:productObjectDictionary];
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





- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray withDelegate:(id)theDelegate
{
    [self handleLayoutWithDelegate:theDelegate];
    int startValue = theIndexPath.row * 3;
    
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
