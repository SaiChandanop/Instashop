//
//  ImagesTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImagesTableViewCell.h"
#import "ImageAPIHandler.h"
#import "ImagesTableCellButton.h"

@implementation ImagesTableViewCell

@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        
    }
    return self;
}


- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray
{

/*    NSArray *subviewsArray = [self subviews];
    for (int i = 0; i < [subviewsArray count]; i++)
        [[subviewsArray objectAtIndex:i] removeFromSuperview];
  */
    
    int startValue = theIndexPath.row * 3;
    
    float spacer = 8;
    float imageWidth = self.frame.size.width / 3 - 11;
    
    float fontHeight = 12;
    
    int iter = 0;
    
    
    for (int i = startValue; i < startValue + 3 && i < [feedItemsArray count]; i++)
    {
        
        UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];
        [self addSubview:theImageView];
    
        
        NSDictionary *productObjectDictionary = [feedItemsArray objectAtIndex:i];
        NSString *productURL = [productObjectDictionary objectForKey:@"products_url"];
        if (productURL == nil)
        {
            NSDictionary *imagesDictionary = [productObjectDictionary objectForKey:@"images"];
            if (imagesDictionary != nil)
            {
                NSDictionary *standardResolutionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
                productURL = [standardResolutionDictionary objectForKey:@"url"];
            }
        }
        
        if (productURL != nil)
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:productURL withImageView:theImageView];
        

        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(theImageView.frame.origin.x, (imageWidth + 2) / 2 - fontHeight / 2, theImageView.frame.size.width, fontHeight + 1)];
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.textColor = [UIColor whiteColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.font = [UIFont systemFontOfSize:fontHeight];
        theLabel.text = @"asdf";//[productObjectDictionary objectForKey:@"products_name"];
        [self addSubview:theLabel];
        [theLabel release];
        
    
        iter++;
        
        ImagesTableCellButton *coverButton = [[ImagesTableCellButton alloc] initWithFrame:theImageView.frame];
        coverButton.objectDictionary = productObjectDictionary;
        [coverButton addTarget:self action:@selector(coverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = [UIColor clearColor];
        [self addSubview:coverButton];
        
    }
        
}

-(void)coverButtonHit:(ImagesTableCellButton *)theButton
{
//    NSLog(@"selection: %@", theButton.objectDictionary);
    [self.delegate cellSelectionOccured:theButton.objectDictionary];
}




@end
