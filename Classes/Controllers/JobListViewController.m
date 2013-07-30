//
//  JobListViewController.m
//  
//
//  Created by Ramiro Diaz on 12/07/13.
//
//

#import "JobListViewController.h"
#import "JobsCollection.h"
#import "JobModel.h"
#import "JobCell.h"
#import "ServiceHelper.h"
#import "JobDetailViewController.h"


@interface JobListViewController ()
@property (nonatomic, strong) JobsCollection *collection;
@end

@implementation JobListViewController {
@private
    __strong UIActivityIndicatorView *_activityIndicatorView;
}

@synthesize collection;

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [JobsCollection getCollectionUsingService:@"SearchJobsService" params: NULL successBlock:^(BaseCollectionModel *_collection) {

        self.collection = (JobsCollection*)_collection;
        [self.tableView reloadData];
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    } failureBlock:^(NSError *error) {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Search Jobs", nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
    
    self.tableView.rowHeight = 70.0f;
    
    [self reload:nil];
}

- (void)viewDidUnload {
    _activityIndicatorView = nil;
    
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [collection.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    JobCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[JobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.job = [collection.data objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JobCell heightForCell: collection.data[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JobModel *job = [collection data] [indexPath.row];
    
    NSDictionary *dict = @{kParamJobId:job.jobId};
    
    [ServiceHelper getModelUsingService:@"JobModelService" forClass: [JobModel class] params: dict
     
              successBlock:^(BaseModel *model) {
                  [self showDetailPageWithModel: (JobModel*)model];
              } failureBlock:^(NSError *error) {
                  
    }];
    
}

- (void) showDetailPageWithModel: (JobModel*) model {
    JobDetailViewController *jobDetail = [JobDetailViewController new];
    jobDetail.job = model;
    [self.navigationController pushViewController:  jobDetail animated: YES];
}

- (void)scrollViewDidScroll: (UIScrollView*) scrollView {
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = self.tableView.contentOffset.y;
    NSInteger maximumOffset = self.tableView.contentSize.height - self.tableView.frame.size.height;
    

    if (maximumOffset - currentOffset <= self.tableView.rowHeight && collection.morePages) {
        [collection loadMoreWithSuccessBlock:^(BaseCollectionModel *collection) {
            [self.tableView reloadData];
            [_activityIndicatorView stopAnimating];
            [_activityIndicatorView stopAnimating];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } failureBlock:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];

            [_activityIndicatorView stopAnimating];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
}

@end

