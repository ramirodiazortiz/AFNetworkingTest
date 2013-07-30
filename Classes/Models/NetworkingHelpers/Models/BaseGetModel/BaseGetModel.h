//
//  GetModel.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 12/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseGetModel : NSObject

+ (void) getModelWithParams:(NSDictionary*) dict
               successBlock:(void (^)(NSObject* model))successBlock
               failureBlock:(void (^)(NSError *error))failureBlock;

//return the class for the model returned
+ (Class) classForModel;

//Return a dictionary with a translation for those attributes whose name is different in server response. The key is the name in dictionary, the value is the name of the property
+ (NSDictionary*) translatePathForModelKey;
+ (NSString*) getServiceURL;
@end
