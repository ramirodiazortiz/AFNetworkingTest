#import "BaseCollectionModel.h"
#import "AvatureApiClient.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"

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
        
        NSDictionary *mappingKeysForItemsInCollection = [[self class] translatePathForItemKeyInCollection];
        NSDictionary *mappingKeysForCollection =  [[self class] translatePathForKeyInCollection];
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

#pragma mark - Must be overridden

+ (NSString*) getServiceURL {
    //Override
    [NSException raise: NSLocalizedString(@"Method not overrided on subclass", nil) format: NSLocalizedString(@"You need to override this method in your own class.", nil)];
    return NULL;
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

+ (NSDictionary*) translatePathForKeyInCollection {
    //Override
    return nil;
}

+ (NSDictionary*) translatePathForItemKeyInCollection {
    //Override
    return nil;    
}

+ (int) itemsPerPage {
    return kItemsPerPage;
}

+ (void) getCollectionWithParams:(NSDictionary*) dict successBlock:(void (^)(BaseCollectionModel* collection))successBlock failureBlock:(void (^)(NSError *error))failureBlock {

    [[AvatureApiClient sharedClient] getPath: [self  getServiceURL] parameters: dict

        success:^(AFHTTPRequestOperation *operation, id JSON) {

        BaseCollectionModel * bc = [[self class] mappObjectWithJSON: JSON];

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

- (void) loadMoreWithParams:(NSDictionary*) dict successBlock:(void (^)(BaseCollectionModel* collection))successBlock failureBlock:(void (^)(NSError *error)) failureBlock {
    
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.data.count];
    NSDictionary *params = @{kParamOffset: pageNumber};
    

    if (!self.refreshing) {
        self.refreshing = YES;
        
        [[self class] getCollectionWithParams: params successBlock:^(BaseCollectionModel *collection) {
           
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
