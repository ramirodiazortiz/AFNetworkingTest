//
//  GetModel.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 12/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "ServiceHelper.h"
#import "AvatureApiClient.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "JobModel.h"


@implementation ServiceHelper
static DCParserConfiguration *parserConfiguration;

#pragma mark - Class Methods

+ (id) mappObjectWithJSON: (id) JSON andModelClass: (Class) modelClass{
    
    
    if (!modelClass) {
        return NULL;
    }
    
    if (![modelClass isSubclassOfClass: [BaseModel class]] ||  !modelClass) {
        [NSException raise: NSLocalizedString(@"modelClass must be subclass of BaseModel", nil) format: NSLocalizedString(@"You need to override BaseModel on modelClass.", nil)];
        return NULL;
    }

    if (!parserConfiguration) {
        parserConfiguration = [DCParserConfiguration configuration];
        NSDictionary *mappingKeysForModel =  [modelClass propertiesToDictionaryEntriesMapping];
        [ServiceHelper mappingKeysForModel: mappingKeysForModel  onClass: modelClass];
    }
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [JobModel class] andConfiguration: parserConfiguration];
    return [parser parseDictionary: JSON];
}

+ (void) mappingKeysForModel: (NSDictionary*) mappingKeysForModel onClass:(Class) class{
    for (NSString *key in mappingKeysForModel) {
        NSString* value = [mappingKeysForModel valueForKey: key];
        if (value) {
            DCObjectMapping *objMap = [DCObjectMapping mapKeyPath: key toAttribute: value onClass: class];
            [parserConfiguration addObjectMapping: objMap];
        }
    }
}

#pragma mark - Instance Methods

+ (NSString*) getURLForService:(NSString*) serviceId {
    return [[AvatureApiClient sharedClient] getURLForResource: serviceId];
}

+ (void) callSuccessBlocksIfNecessary:(void (^)(BaseModel* model))successBlock andModel:(BaseModel*) model {
    if (successBlock) {
        successBlock(model);
    }
}

+ (void) callFailureBlocksIfNecessary:(void (^)(NSError *error))failureBlock andError:(NSError*) error {
    if (failureBlock) {
        failureBlock(error);
    }
}

+ (void) getModelUsingService:(NSString*) serviceId forClass:(Class) className params:(NSDictionary*) dict successBlock:(void (^)(BaseModel* model))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    [[AvatureApiClient sharedClient] getPath: [ServiceHelper getURLForService: serviceId] parameters: dict
     
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         JobModel * model = [ServiceHelper mappObjectWithJSON: JSON andModelClass: className];
                                         [ServiceHelper callSuccessBlocksIfNecessary: successBlock andModel: model];
                                    
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [ServiceHelper callFailureBlocksIfNecessary: failureBlock andError:error];
                                     }];
}

+ (void) postDataUsingService:(NSString*) serviceId forClass:(Class) className params:(NSDictionary*) dict successBlock:(void (^)(BaseModel* model))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    [[AvatureApiClient sharedClient] postPath: [ServiceHelper getURLForService: serviceId] parameters: dict
     
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                       [ServiceHelper callSuccessBlocksIfNecessary: successBlock andModel: NULL];
                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [ServiceHelper callFailureBlocksIfNecessary: failureBlock andError:error];
                                     }];
}

@end
