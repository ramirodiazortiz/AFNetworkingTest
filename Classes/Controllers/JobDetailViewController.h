//
//  JobDetailViewController.h
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 12/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  JobModel;

@interface JobDetailViewController : UIViewController {
    
    IBOutlet UILabel *jobName;
    IBOutlet UILabel *jobLocation;
    IBOutlet UILabel *jobId;
    IBOutlet UILabel *jobDate;
    IBOutlet UITextField *lastName;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *personalEmail;
}

@property (nonatomic, strong) JobModel *job;
@end
