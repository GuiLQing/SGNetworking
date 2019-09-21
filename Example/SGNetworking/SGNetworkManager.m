//
//  SGNetworkManager.m
//  Pods-SGNetworking_Example
//
//  Created by SG on 2019/9/18.
//

#import "SGNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "SGMacros.h"

static inline NSString * SG_RequestLink(NSString *serverAddress, NSString *interface) {
    if (!serverAddress || !interface) return @"";
    return [serverAddress stringByAppendingPathComponent:interface];
}

static NSTimeInterval const SG_DEFAULT_TIMEOUT_INTERVAL = 30.0;

@interface SGNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) void (^success)(id response);

@property (nonatomic, strong) void (^failure)(NSError *error);

@property (nonatomic, strong) void (^downloadProgress)(NSProgress *progress);

@property (nonatomic, strong) NSString *serverAddress;

@property (nonatomic, strong) NSString *interface;

@property (nonatomic, strong) NSDictionary *parameters;

@end

@implementation SGNetworkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        
        _sessionManager.requestSerializer = AFJSONRequestSerializer.serializer;
        _sessionManager.requestSerializer.timeoutInterval = SG_DEFAULT_TIMEOUT_INTERVAL;
        
        _sessionManager.responseSerializer = AFHTTPResponseSerializer.serializer;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        
        _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    return self;
}

+ (SGNetworkManager *)sg_sharedManager {
    static SGNetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SGNetworkManager alloc] init];
    });
    return _sharedManager;
}

+ (SGNetworkManager *)sg_manager {
    return [[SGNetworkManager alloc] init];
}

- (SGNetworkManager * (^)(void (^)(id response)))sg_success {
    SG_weakify(self)
    return ^(void (^sg_success)(id response)) {
        SG_strongify(self)
        self.success = ^(id response) {
            if (sg_success) sg_success(response);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(void (^)(NSError *error)))sg_failure {
    SG_weakify(self)
    return ^(void (^sg_failure)(NSError *error)) {
        SG_strongify(self)
        self.failure = ^(NSError *error) {
            if (sg_failure) sg_failure(error);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(void (^)(NSProgress *progress)))sg_downloadProgress {
    SG_weakify(self)
    return ^(void (^sg_downloadProgress)(NSProgress *progress)) {
        SG_strongify(self)
        self.downloadProgress = ^(NSProgress *progress) {
            if (sg_downloadProgress) sg_downloadProgress(progress);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(NSString *serverAddress))sg_serverAddress {
    SG_weakify(self)
    return ^(NSString *serverAddress) {
        SG_strongify(self)
        self.serverAddress = serverAddress;
        return self;
    };
}

- (SGNetworkManager * (^)(NSString *interface))sg_interface {
    SG_weakify(self)
    return ^(NSString *interface) {
        SG_strongify(self)
        self.interface = interface;
        return self;
    };
}

- (SGNetworkManager * (^)(NSDictionary *parameters))sg_parameters {
    SG_weakify(self)
    return ^(NSDictionary *parameters) {
        SG_strongify(self)
        self.parameters = parameters;
        return self;
    };
}

- (SGNetworkManager *)get {
    SG_weakify(self)
    [self.sessionManager GET:SG_RequestLink(self.serverAddress, self.interface) parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        SG_strongify(self)
        if (self.downloadProgress) self.downloadProgress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SG_strongify(self)
        if (self.success) self.success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SG_strongify(self)
        if (self.failure) self.failure(error);
    }];
    return self;
}

@end
