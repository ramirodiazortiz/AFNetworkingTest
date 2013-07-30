//
//  JobCollection.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 03/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "JobsCollection.h"
#import "JobModel.h"

@implementation JobsCollection


+ (NSString*) attributeCollectionNameInResponse {
    return @"data";
}

+ (Class) classForItemsInCollection {
    //Override
    return [JobModel class];
}



@end
