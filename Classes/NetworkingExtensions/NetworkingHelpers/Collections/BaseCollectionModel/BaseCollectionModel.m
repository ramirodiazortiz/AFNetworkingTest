#import "BaseCollectionModel.h"
#import "AvatureApiClient.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "BaseModel.h"


@interface BaseCollectionModel() {
   
}
@property (nonatomic) BOOL refreshing;
@end


@implementation BaseCollectionModel 
static DCParserConfiguration *parserConfiguration;



#pragma mark - Class Methods

+ (id) mappObjectWithJSON: (id) JSON {

    if (!parserConfiguration) {
        parserConfiguration = [DCParserConfiguration configuration];
        DCObjectMapping *arrayObjectMapping = [DCObjectMapping mapKeyPath:[self attributeCollectionNameInResponse] toAttribute: kCollectionKeyPath onClass: [self class]];
        DCArrayMapping *mapper = [DCArrayMapping mapperForClass: [self classForItemsInCollection] onMapping: arrayObjectMapping];
        
        NSDictionary *mappingKeysForItemsInCollection = [BaseModel propertiesToDictionaryEntriesMapping];
        NSDictionary *mappingKeysForCollection =  [[self class] propertiesToDictionaryEntriesMapping];
        
        [BaseCollectionModel mappingKeysForItemsInCollection: mappingKeysForCollection  onClass: [self class]];
        [BaseCollectionModel mappingKeysForItemsInCollection: mappingKeysForItemsInCollection  onClass: [self classForItemsInCollection]];
        
        [parserConfiguration addArrayMapper:mapper];
    }

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass: [self class]  andConfiguration:parserConfiguration];
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

#pragma mark - Can be overridden


+ (NSString*) attributeCollectionNameInResponse {
    //Override
    return kCollectionKeyPath;
}


+ (Class) classForItemsInCollection {
    //Override
    return [NSObject class];
}

+ (NSDictionary*) propertiesToDictionaryEntriesMapping {
    //Override
    return nil;
}


+ (int) itemsPerPage {
    return kItemsPerPage;
}

+ (void)  getCollectionUsingService:(NSString*) serviceId params:(NSDictionary*) dict successBlock:(void (^)(BaseCollectionModel* collection))successBlock failureBlock:(void (^)(NSError *error))failureBlock {

    AvatureApiClient *client = [AvatureApiClient sharedClient];
    
    NSString* serviceURL = [client getURLForResource: serviceId];
    
    [[AvatureApiClient sharedClient] getPath: serviceURL parameters: dict

        success:^(AFHTTPRequestOperation *operation, id JSON) {

        BaseCollectionModel * bc = [[self class] mappObjectWithJSON: JSON];
        bc.serviceId = serviceId;

        if (successBlock) {
            successBlock(bc);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Collection Refresh

- (void) loadMoreWithSuccessBlock:(void (^)(BaseCollectionModel* collection))successBlock failureBlock:(void (^)(NSError *error)) failureBlock {
    
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.data.count];
    NSDictionary *params = @{kParamOffset: pageNumber};
    

    if (!self.refreshing) {
        self.refreshing = YES;
        
        [[self class] getCollectionUsingService: self.serviceId params: params successBlock:^(BaseCollectionModel *collection) {

            NSMutableArray *aux = [NSMutableArray arrayWithArray: self.data];
            [aux addObjectsFromArray: collection.data];
            self.data = [NSArray arrayWithArray: aux];
            self.morePages = collection.morePages;
            
            if (successBlock) {
                successBlock(self);
                self.refreshing = NO;
            }
            

        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
                self.refreshing = NO;
            }
        }];
    }
}


@end
