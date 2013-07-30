//
//  GetModel.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 12/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "BaseGetModel.h"
#import "AvatureApiClient.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"

@implementation BaseGetModel
static DCParserConfiguration *parserConfiguration;

#pragma mark - Class Methods

+ (id) mappObjectWithJSON: (id) JSON {
    
    if (!parserConfiguration) {
        parserConfiguration = [DCParserConfiguration configuration];
        NSDictionary *mappingKeysForModel =  [[self class] translatePathForModelKey];
        [BaseGetModel mappingKeysForItemsInCollection: mappingKeysForModel  onClass: [self classForModel]];
    }
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [self classForModel]  andConfiguration:parserConfiguration];
    return [parser parseDictionary: JSON];
}

+ (void) mappingKeysForItemsInCollection: (NSDictionary*) mappingKeysForItemsInCollection onClass:(Class) class{
    for (NSString *key in mappingKeysForItemsInCollection) {
        NSString* value = [mappingKeysForItemsInCollection valueForKey: key];
        if (value) {
            DCObjectMapping *objMap = [DCObjectMapping mapKeyPath: key toAttribute: value onClass: class];
            [parserConfiguration addObjectMapping: objMap];
        }
    }
}

#pragma mark - Must be overridden

+ (NSString*) getServiceURL {
    //Override
    [NSException raise: NSLocalizedString(@"Method not overrided on subclass", nil) format: NSLocalizedString(@"You need to override this method in your own class.", nil)];
    return NULL;
}


#pragma mark - Can be overridden

+ (Class) classForModel {
    //Override
    return [NSObject class];
}

+ (NSDictionary*) translatePathForModelKey {
    //Override
    return nil;
}


+ (void) getCollectionWithParams:(NSDictionary*) dict successBlock:(void (^)(NSObject* model))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    [[AvatureApiClient sharedClient] getPath: [self  getServiceURL] parameters: dict
     
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         
                                         NSObject * object = [[self classForModel] mappObjectWithJSON: JSON];
                                       
                                         if (successBlock) {
                                             successBlock(object);
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failureBlock) {
                                             failureBlock(error);
                                         }
                                     }];
}


@end
