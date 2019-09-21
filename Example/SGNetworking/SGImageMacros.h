//
//  SGImageMacros.h
//  SGNetworking
//
//  Created by SG on 2019/9/20.
//  Copyright © 2019 SG. All rights reserved.
//

#ifndef SGImageMacros_h
#define SGImageMacros_h

/** 处理带有中文的图片链接utf8编码，使用了正则表达式判断，如果没有中文则原样返回 */
static inline NSString * _Nonnull SG_HandleImageUrl(NSString * _Nonnull urlString) {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSArray *resultArray = [regex matchesInString:urlString options:0 range:NSMakeRange(0, urlString.length)];
        resultArray = [resultArray reverseObjectEnumerator].allObjects;
        for (NSTextCheckingResult *result in resultArray) {
            NSString *resultString = [urlString substringWithRange:result.range];
            urlString = [urlString stringByReplacingCharactersInRange:result.range withString:[resultString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        }
    }
    return urlString;
}

#endif /* SGImageMacros_h */
