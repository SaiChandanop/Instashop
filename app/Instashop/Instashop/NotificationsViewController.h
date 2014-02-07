//
//  NotificationsViewController.h
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsFinishedProtocol.h"
#import "IGRequest.h"

@interface NotificationsViewController : UIViewController <NotificationsFinishedProtocol, UITableViewDataSource, UITableViewDelegate, IGRequestDelegate>
{
    UITableView *theTableView;
    NSMutableArray *contentArray;
    NSMutableDictionary *referenceCache;
    NSMutableArray *requestedCacheIDs;
    NSMutableArray *cacheQueue;
    BOOL cacheQueueBegun;
    NSMutableArray *tableCellsArray;
}

-(void)loadNotifications;

-(NSDictionary *)getDictionaryFromCacheWithID:(NSString *)theID;
-(void)setDictionaryIntoCacheWithID:(NSString *)theID withDictionary:(NSDictionary *)theDictionary;

@property (nonatomic, strong) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableDictionary *referenceCache;
@property (nonatomic, strong) NSMutableArray *requestedCacheIDs;
@property (nonatomic, strong) NSMutableArray *cacheQueue;
@property (nonatomic, assign) BOOL cacheQueueBegun;
@property (nonatomic, strong) NSMutableArray *tableCellsArray;
@end
