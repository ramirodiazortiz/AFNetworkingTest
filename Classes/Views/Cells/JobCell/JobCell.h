//
//  JobCell.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 03/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JobModel;

@interface JobCell : UITableViewCell

@property (nonatomic, strong) JobModel *job;

+ (CGFloat)heightForCell:(JobModel *)jobModel;

@end
