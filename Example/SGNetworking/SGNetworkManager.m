//
//  SGNetworkManager.m
//  Pods-SGNetworking_Example
//
//  Created by SG on 2019/9/18.
//

#import "SGNetworkManager.h"
#import <AFNetworking/AFNetworking.h>

#ifndef SGNET_weakify
#if __has_feature(objc_arc)
#define SGNET_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
@autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")
#else

#define SGNET_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
@autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")
#endif
#endif

#ifndef SGNET_strongify
#if __has_feature(objc_arc)
#define SGNET_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
@try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")
#else

#define SGNET_strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
@try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")
#endif
#endif

static inline NSString * SGNET_RequestLink(NSString *serverAddress, NSString *interface) {
    if (!serverAddress || !interface) return @"";
    return [serverAddress stringByAppendingPathComponent:interface];
}

static NSTimeInterval const SG_DEFAULT_TIMEOUT_INTERVAL = 30.0;

@interface SGNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) void (^success)(id response);

@property (nonatomic, strong) void (^failure)(NSError *error);

@property (nonatomic, strong) void (^downloadProgress)(NSProgress *progress);

@property (nonatomic, strong) void (^uploadProgress)(NSProgress *progress);

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
    SGNET_weakify(self)
    return ^(void (^sg_success)(id response)) {
        SGNET_strongify(self)
        self.success = ^(id response) {
            if (sg_success) sg_success(response);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(void (^)(NSError *error)))sg_failure {
    SGNET_weakify(self)
    return ^(void (^sg_failure)(NSError *error)) {
        SGNET_strongify(self)
        self.failure = ^(NSError *error) {
            if (sg_failure) sg_failure(error);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(void (^)(NSProgress *progress)))sg_downloadProgress {
    SGNET_weakify(self)
    return ^(void (^sg_downloadProgress)(NSProgress *progress)) {
        SGNET_strongify(self)
        self.downloadProgress = ^(NSProgress *progress) {
            if (sg_downloadProgress) sg_downloadProgress(progress);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(void (^)(NSProgress *progress)))sg_uploadProgress {
    SGNET_weakify(self)
    return ^(void (^sg_uploadProgress)(NSProgress *progress)) {
        SGNET_strongify(self)
        self.uploadProgress = ^(NSProgress *progress) {
            if (sg_uploadProgress) sg_uploadProgress(progress);
        };
        return self;
    };
}

- (SGNetworkManager * (^)(NSString *serverAddress))sg_serverAddress {
    SGNET_weakify(self)
    return ^(NSString *serverAddress) {
        SGNET_strongify(self)
        self.serverAddress = serverAddress;
        return self;
    };
}

- (SGNetworkManager * (^)(NSString *interface))sg_interface {
    SGNET_weakify(self)
    return ^(NSString *interface) {
        SGNET_strongify(self)
        self.interface = interface;
        return self;
    };
}

- (SGNetworkManager * (^)(NSDictionary *parameters))sg_parameters {
    SGNET_weakify(self)
    return ^(NSDictionary *parameters) {
        SGNET_strongify(self)
        self.parameters = parameters;
        return self;
    };
}

- (SGNetworkManager *)get {
    SGNET_weakify(self)
    [self.sessionManager GET:SGNET_RequestLink(self.serverAddress, self.interface) parameters:self.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        SGNET_strongify(self)
        if (self.downloadProgress) self.downloadProgress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SGNET_strongify(self)
        if (self.success) self.success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SGNET_strongify(self)
        if (self.failure) self.failure(error);
    }];
    return self;
}

- (SGNetworkManager *)post {
    SGNET_weakify(self)
    [self.sessionManager POST:SGNET_RequestLink(self.serverAddress, self.interface) parameters:self.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        SGNET_strongify(self)
        if (self.uploadProgress) self.uploadProgress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SGNET_strongify(self)
        if (self.success) self.success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SGNET_strongify(self)
        if (self.failure) self.failure(error);
    }];
    return self;
}

@end
