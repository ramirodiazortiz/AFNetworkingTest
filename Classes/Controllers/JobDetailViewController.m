//
//  JobDetailViewController.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 12/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "JobDetailViewController.h"
#import "JobModel.h"
#import "ServiceHelper.h"


@interface JobDetailViewController ()

@end

@implementation JobDetailViewController


- (IBAction)onApplyTUI:(id)sender {
    [self applyForJob];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    jobName.text = self.job.name;
    jobLocation.text = self.job.location;
    jobId.text = [NSString stringWithFormat: @"Job ID: %@", self.job.jobId];
    jobDate.text = self.job.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) applyForJob {
    NSDictionary *dict = @{kParamJobId: self.job.jobId, kParamFirstName: firstName.text, kParamLastName:lastName.text, kParamPersonalEmail: personalEmail.text, kParamSourceId: @"6", kParamMode: @"create" ,kParamEntityData: @"null", kParamPortalMode: @"create"};

#define kParamSourceId @"sourceId"
#define kParamMode @"mode"
#define kParamReferer @"referer"
#define kParamStepIndex @"currentStepIndex"
#define kParamEntityData @"entityData"
#define kParamPortalMode @"portalMode"
    
    [ServiceHelper postDataUsingService:@"RegisterService" forClass: NULL params: dict successBlock:^(BaseModel *model) {
        int a = 0;
        a ++;
    } failureBlock:^(NSError *error) {
        int b = 0;
        b ++;
    }];
    
}
@end
