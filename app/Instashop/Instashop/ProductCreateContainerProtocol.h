//
//  ProductCreateContainerProtocol.h
//  Instashop
//
//  Created by Josh Klobe on 8/20/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductCreateContainerObject.h"

@protocol ProductCreateContainerProtocol <NSObject>


-(void)productContainerCreateFinishedWithProductID:(NSString *)productID withProductCreateContainerObject:(ProductCreateContainerObject *)productCreateContainerObject;
@end
