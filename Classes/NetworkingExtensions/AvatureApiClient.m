
#import "AvatureApiClient.h"
#import "AFJSONRequestOperation.h"

#define kBaseURL @"http://iats.ramiro.diaz.xcade.net/"
@interface AvatureApiClient() {
  
}
@property (nonatomic, strong) NSDictionary *servicesURLS;
@end

@implementation AvatureApiClient

+ (AvatureApiClient *)sharedClient {
    static AvatureApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSDictionary *urlsDict = [AvatureApiClient getServicesURLS];
        NSString *url = [AvatureApiClient getURLForResource: @"DebugBaseServerURL" onDic: urlsDict];
        
        _sharedClient = [[AvatureApiClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
        [_sharedClient setServicesURLS: urlsDict];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
 
    
    return self;
}

- (NSString*) getURLForResource: (NSString*) resource {
    NSString *uri = [AvatureApiClient getURLForResource: resource onDic: self.servicesURLS];
    return uri;
}

+ (NSString*) getURLForResource: (NSString*) resource  onDic:(NSDictionary*) dictionary{
    NSString *uri = [dictionary valueForKey: resource];
    return uri;
}



+ (NSDictionary*) getServicesURLS {
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"ServicesURLS" ofType:@"plist"];
    
    return [[NSDictionary alloc] initWithContentsOfFile: path];
}



@end
