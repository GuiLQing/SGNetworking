//
//  SGPathMacros.h
//  SGNetworking
//
//  Created by SG on 2019/9/20.
//  Copyright © 2019 SG. All rights reserved.
//

#ifndef SGPathMacros_h
#define SGPathMacros_h

/** 路径拼接 */
static inline NSString * _Nonnull SG_AppendPathComponent(NSString * _Nonnull path, NSString * _Nullable lastPathComponent) {
    if (lastPathComponent && ![lastPathComponent isEqualToString:@""]) {
        if ([lastPathComponent hasPrefix:@"/"]) {
            path = [path stringByAppendingString:lastPathComponent];
        } else {
            path = [path stringByAppendingPathComponent:lastPathComponent];
        }
    }
    return path;
}

static inline NSString * _Nonnull SG_PathTemp(NSString * _Nullable lastPathComponent) {
    NSString *pathTemp = NSTemporaryDirectory();
    return SG_AppendPathComponent(pathTemp, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathDocument(NSString * _Nullable lastPathComponent) {
    NSString *pathDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return SG_AppendPathComponent(pathDocument, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathCache(NSString * _Nullable lastPathComponent) {
    NSString *pathCache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return SG_AppendPathComponent(pathCache, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathLibraryAppend(NSString * _Nullable lastPathComponent) {
    NSString *pathLibrary = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    return SG_AppendPathComponent(pathLibrary, lastPathComponent);
}

#endif /* SGPathMacros_h */
