#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface AvatureApiClient : AFHTTPClient

+ (AvatureApiClient *)sharedClient;
- (NSString*) getURLForResource: (NSString*) resource;
@end
