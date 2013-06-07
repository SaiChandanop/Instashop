//
//  CategoriesAttributesHandler.m
//  Instashop
//
//  Created by Josh Klobe on 6/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesAttributesHandler.h"

@implementation CategoriesAttributesHandler

static CategoriesAttributesHandler *theHandler;

+(CategoriesAttributesHandler *)sharedCategoryAttributesHandler
{
    
    if (theHandler == nil)
    {
        theHandler = [[CategoriesAttributesHandler alloc] init];
        theHandler.contentDict = [theHandler createDictionary];        
    }
    
    return theHandler;
}

-(NSArray *)getTopCategories
{
    return [self.contentDict allKeys];
}
-(NSDictionary *)createDictionary
{
    NSMutableDictionary *categoryDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithCapacity:0];

#pragma mark womens
    NSArray *sizesArray = [NSArray arrayWithObjects:@"XS", @"S", @"M", @"L", @"XL", @"XXL", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Shirts"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Womens"];
    
    sizesArray = [NSArray arrayWithObjects:@"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Pants"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Womens"];
    
    sizesArray = [NSArray arrayWithObjects:@"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Shoes"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Womens"];

    sizesArray = [NSArray arrayWithObjects:@"XS", @"S", @"M", @"L", @"XL", @"XXL", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Outerwear"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Womens"];

    
    /*
    sizesArray = [NSArray arrayWithObjects:@"4", @"5", @"6", @"7", @"8", @"+", nil];
    
    [attributesDictionary setObject: forKey:@"Swimwear & Lingerie"];
    
    
    sizesArray = [NSArray arrayWithObjects:@"32", @"34", @"36", @"38", nil];
    NSDictionary *brasDictionaryA = [NSDictionary dictionaryWithObject:sizesArray forKey:@"Band Size"];

    sizesArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"DD", @"DDD", nil];
    NSDictionary *brasDictionaryA = [NSDictionary dictionaryWithObject:sizesArray forKey:@"Cup Size"];

    
    [NSDictionary dictionaryWithObject:sizesArray forKey:@"Panties"]
    [attributesDictionary setObject:forKey:@"Swimwear & Linger/ie"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Womens"];

    

    Swimwear & Lingerie
    Panties
    4, 5, 6, 7, 8, 9
    Bras
    Band Size
    32, 34, 36, 38
    Cup Size
    A, B, C, D, DD, DDD

    */

#pragma mark Mens
    sizesArray = [NSArray arrayWithObjects:@"XS", @"S", @"M", @"L", @"XL", @"XXL", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Shirts"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Mens"];

    sizesArray = [NSArray arrayWithObjects:@"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36",  nil];
    [attributesDictionary setObject:sizesArray forKey:@"Pants"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Mens"];

    sizesArray = [NSArray arrayWithObjects:@"S", @"M", @"L", @"XL",  nil];
    [attributesDictionary setObject:sizesArray forKey:@"Underwear"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Mens"];

    sizesArray = [NSArray arrayWithObjects:@"8", @"8.5", @"9", @"9.5", @"10", @"10.5", @"11", @"11.5", @"12", @"12.5", @"13", @"13.5", @"14", @"14.5", @"15", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Shoes"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Mens"];

    sizesArray = [NSArray arrayWithObjects:@"S", @"M", @"L", @"XL", @"XXL", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Outerwear"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Mens"];

    sizesArray = [NSArray arrayWithObjects:@"S", @"M", @"L", @"XL", @"XXL", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Swimware"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Mens"];


#pragma mark Accessories
    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Watches"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Accessories"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Sunglasses & Eyewear"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Accessories"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Belts"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Accessories"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Hats"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Accessories"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Scarves"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Accessories"];

    
    
#pragma mark Jewelry
    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Bracelets"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Jewelry"];

    sizesArray = [NSArray arrayWithObjects:@"7", @"7.5", @"8", @"8.5", @"9", @"9.5", @"10", @"10.5", @"11", @"11.5", @"12", @"12.5", @"13", nil];
    [attributesDictionary setObject:sizesArray forKey:@"Rings"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Jewelry"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Earrings"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Jewelry"];
    
    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Necklaces"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Jewelry"];

    
#pragma mark Health & Beauty
    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Makeup"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Health & Beauty"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Nails"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Health & Beauty"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Hair"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Health & Beauty"];
    
    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Vitamins"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Health & Beauty"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Supplements"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Health & Beauty"];

    
#pragma mark Tech and gadgets
    
    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Home"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Tech & Gadgets"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Art"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Tech & Gadgets"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Sports"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Tech & Gadgets"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Pets"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Tech & Gadgets"];

    [attributesDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Other"];
    [categoryDictionary setObject:attributesDictionary forKey:@"Tech & Gadgets"];

    
    
//    NSLog(@"categoryDictionary[Mens]: %@", [[categoryDictionary objectForKey:@"Mens"] allKeys]);
    
    
    return categoryDictionary;
 }


@end
