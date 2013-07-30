//
//  Job.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 03/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface JobModel : BaseModel

@property (nonatomic, strong) NSString *jobId;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;

@end
