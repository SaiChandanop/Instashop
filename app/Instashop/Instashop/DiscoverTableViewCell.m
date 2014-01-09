//
//  DiscoverTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 11/5/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "DiscoverTableViewCell.h"

@implementation DiscoverTableViewCell



@synthesize itemOne;
@synthesize itemTwo;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void) handleLayoutWithDelegate:(id)theDelegate
{
    float imageWidth = self.frame.size.width / 2;
    
    if (self.itemOne == nil)
    {
        self.itemOne = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [self addSubview:self.itemOne];
    }
    
    if (self.itemTwo == nil)
    {
        self.itemTwo = [[ImagesTableViewItem alloc] initWithFrame:CGRectMake(imageWidth, 0, imageWidth, imageWidth)];
        [self addSubview:self.itemTwo];
    }
    
    
    
    self.itemOne.delegate = theDelegate;
    self.itemTwo.delegate = theDelegate;
    
    
    [self.itemOne cleanContent];
    [self.itemTwo cleanContent];
    
}




- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray withDelegate:(id)theDelegate
{
    [self handleLayoutWithDelegate:theDelegate];
    int startValue = theIndexPath.row * 2;
    
    for (int i = 0; i < 2; i++)
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
                    
                default:
                    break;
            }
        }
        
    }
    
    [self bringSubviewToFront:self.itemOne];
    [self bringSubviewToFront:self.itemTwo];
    
}





@end
