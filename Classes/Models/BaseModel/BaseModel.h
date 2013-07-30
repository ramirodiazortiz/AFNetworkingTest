//
//  BaseModel.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 15/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


//Return a dictionary with a translation for those attributes for objects inside the collection whose name is different in server response. The key is the name in dictionary, the value is the name of the property
+ (NSDictionary*) propertiesToDictionaryEntriesMapping;

@end
