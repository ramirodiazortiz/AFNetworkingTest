//
//  JobCollection.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 03/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "JobsCollection.h"
#import "AvatureApiClient.h"
#import "JobModel.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "Constants.h"

@implementation JobsCollection


+ (NSDictionary*) translatePathForItemKeyInCollection {
    return @{@"imageJob": @"imageUrl"};
}


+ (NSString*) attributeCollectionNameInResponse {
    return @"data";
}

+ (Class) classForItemsInCollection {
    //Override
    return [JobModel class];
}

+ (NSString*) getServiceURL {
    return kJobSearchURL;
}


- (NSDictionary *)propertiesToDictionaryEntriesMapping
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"jobModelArray", @"jobModel", 
            nil];
}
@end
