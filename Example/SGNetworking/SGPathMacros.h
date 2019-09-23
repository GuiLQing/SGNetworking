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

static inline NSString * _Nonnull SG_HomeAppend(NSString * _Nullable lastPathComponent) {
    NSString *homeTemp = NSHomeDirectory();
    return SG_AppendPathComponent(homeTemp, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathTempAppend(NSString * _Nullable lastPathComponent) {
    NSString *pathTemp = NSTemporaryDirectory();
    return SG_AppendPathComponent(pathTemp, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathDocumentAppend(NSString * _Nullable lastPathComponent) {
    NSString *pathDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return SG_AppendPathComponent(pathDocument, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathCacheAppend(NSString * _Nullable lastPathComponent) {
    NSString *pathCache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return SG_AppendPathComponent(pathCache, lastPathComponent);
}

static inline NSString * _Nonnull SG_PathLibraryAppend(NSString * _Nullable lastPathComponent) {
    NSString *pathLibrary = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    return SG_AppendPathComponent(pathLibrary, lastPathComponent);
}

static inline NSString * _Nonnull SG_Home(void) {
    return SG_HomeAppend(nil);
}

static inline NSString * _Nonnull SG_PathTemp(void) {
    return SG_PathTempAppend(nil);
}

static inline NSString * _Nonnull SG_PathDocument(void) {
    return SG_PathDocumentAppend(nil);
}

static inline NSString * _Nonnull SG_PathCache(void) {
    return SG_PathCacheAppend(nil);
}

static inline NSString * _Nonnull SG_PathLibrary(void) {
    return SG_PathLibraryAppend(nil);
}

#endif /* SGPathMacros_h */
