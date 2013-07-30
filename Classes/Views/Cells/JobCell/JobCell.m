//
//  JobCell.m
//  AFNetworkingTest
//
//  Created by Ramiro Diaz on 03/07/13.
//  Copyright (c) 2013 Ramiro Diaz. All rights reserved.
//

#import "JobCell.h"
#import "JobModel.h"
#import "UIImageView+AFNetworking.h"


@implementation JobCell {
@private
__strong JobModel *_job;
}

@synthesize job = _job;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setJob:(JobModel *)job {
    _job = job;
    
    self.textLabel.text = _job.name;
    self.detailTextLabel.text = _job.location;
    NSURL *url = [NSURL URLWithString:job.imageUrl];
    [self.imageView setImageWithURL: url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCell:(JobModel *)jobModel {
    CGSize sizeToFit = [jobModel.name sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX)];
    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = [[self class] heightForCell:_job] - 45.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
