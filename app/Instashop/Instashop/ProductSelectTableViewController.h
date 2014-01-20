//
//  ProductSelectTableViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectSelectTableViewController.h"

@interface ProductSelectTableViewController : ObjectSelectTableViewController
{
    int checkCountup;
    NSMutableArray *cacheArray;
    BOOL loaded;
}

-(void)checkFinishedWithBoolValue:(BOOL)exists withDictionary:(NSMutableDictionary *)referenceDictionary;

@property (nonatomic, assign) int checkCountup;
@property (nonatomic, strong) NSMutableArray *cacheArray;
@property (nonatomic, assign) BOOL loaded;
@end
