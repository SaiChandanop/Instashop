//
//  PullAccountHandler.h
//  Instashop
//
//  Created by Josh Klobe on 3/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGRequest.h"
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "JKProgressView.h"

@interface PullAccountHandler : NSObject <IGRequestDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray *followingArray;
    JKProgressView *jkProgressView;
}

-(void)pullAccount;

@property (nonatomic, retain) NSMutableArray *followingArray;
@property (nonatomic, retain) JKProgressView *jkProgressView;
@end
