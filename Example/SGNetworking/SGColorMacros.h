//
//  SGColorMacros.h
//  SGNetworking
//
//  Created by SG on 2019/9/20.
//  Copyright © 2019 SG. All rights reserved.
//

#ifndef SGColorMacros_h
#define SGColorMacros_h

static inline UIColor * _Nonnull SG_RGBA(NSInteger r, NSInteger g, NSInteger b, CGFloat a) {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

static inline UIColor * _Nonnull SG_RGB(NSInteger r, NSInteger g, NSInteger b) {
    return SG_RGBA(r, g, b, 1.0f);
}

static inline UIColor * _Nonnull SG_HexColorA(NSInteger c, CGFloat a) {
    return [UIColor colorWithRed:((c>>16)&0xFF)/255.0f green:((c>>8)&0xFF)/255.0f blue:(c&0xFF)/255.0f alpha:a];
}

static inline UIColor * _Nonnull SG_HexColor(NSInteger c) {
    return SG_HexColorA(c, 1.0f);
}

static inline UIColor * _Nonnull SG_HexColorString(NSString * _Nonnull rgbValue) {
    rgbValue = [rgbValue stringByReplacingOccurrencesOfString:@"#" withString:@""];
    return [UIColor colorWithRed:((float)((strtoul(rgbValue.UTF8String, 0, 16) & 0xFF0000) >> 16))/255.0 green:((float)((strtoul((rgbValue).UTF8String, 0, 16) & 0xFF00) >> 8))/255.0 blue:((float)(strtoul((rgbValue).UTF8String, 0, 16) & 0xFF))/255.0 alpha:1.0];
}

#endif /* SGColorMacros_h */
