//
//  BaseCollectionModel.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 05/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

//#import "Model.h"
#import "CollectionModelObserver.h"
#import "Observable.h"



@class BaseCollectionModel;


@interface BaseCollectionModel : NSObject
{
}

@property(nonatomic) BOOL morePages;
@property (nonatomic, strong) NSMutableArray *data;

+ (void) getCollectionWithParams:(NSDictionary*) dict
                    successBlock:(void (^)(BaseCollectionModel* collection))successBlock
                    failureBlock:(void (^)(NSError *error))failureBlock;

- (void) loadMoreWithParams:(NSDictionary*) dict successBlock:(void (^)(BaseCollectionModel* collection))successBlock failureBlock:(void (^)(NSError *error)) failureBlock;

+ (NSString*) getServiceURL;

//- (void) tellDelegateCollectionHasChanged;
//- (void) tellDelegateCollectionHasFailedToChange;

//return the collection name in server response
+ (NSString*) attributeCollectionNameInResponse;

//return the class for the items inside the collection
+ (Class) classForItemsInCollection;

//Return a dictionary with a translation for those attributes for objects inside the collection whose name is different in server response. The key is the name in dictionary, the value is the name of the property
+ (NSDictionary*) translatePathForKeyInCollection;

//Return a dictionary with a translation for those attributes whose name is different in server response. The key is the name in dictionary, the value is the name of the property
+ (NSDictionary*) translatePathForItemKeyInCollection;

+ (int) itemsPerPage;
@end
