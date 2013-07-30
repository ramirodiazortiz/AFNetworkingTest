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
@property (nonatomic, strong) NSString *serviceId;

+ (void)  getCollectionUsingService:(NSString*) serviceId params:(NSDictionary*) dict
                    successBlock:(void (^)(BaseCollectionModel* collection))successBlock
                    failureBlock:(void (^)(NSError *error))failureBlock;

- (void) loadMoreWithSuccessBlock:(void (^)(BaseCollectionModel* collection))successBlock failureBlock:(void (^)(NSError *error)) failureBlock;



//- (void) tellDelegateCollectionHasChanged;
//- (void) tellDelegateCollectionHasFailedToChange;

//return the collection name in server response
+ (NSString*) attributeCollectionNameInResponse;

//return the class for the items inside the collection
+ (Class) classForItemsInCollection;

//Return a dictionary with a translation for those attributes whose name is different in server response. The key is the name in dictionary, the value is the name of the property
+ (NSDictionary*) propertiesToDictionaryEntriesMapping;

+ (int) itemsPerPage;
@end
