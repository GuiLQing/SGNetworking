//
//  SGOtherMacros.h
//  SGNetworking
//
//  Created by SG on 2019/9/20.
//  Copyright © 2019 SG. All rights reserved.
//

#ifndef SGOtherMacros_h
#define SGOtherMacros_h

/** 判断链接资源类型 */
static inline void SG_GetVideoMIMITypeFromNSULRSession(NSURL * _Nonnull url, void (^ _Nullable callback)(NSString * _Nonnull MIMEType)) {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    [[NSURLSession.sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (callback) callback(response.MIMEType);
    }] resume];
}

#endif /* SGOtherMacros_h */
