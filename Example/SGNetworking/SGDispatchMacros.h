//
//  SGDispatchMacros.h
//  SGNetworking
//
//  Created by SG on 2019/9/20.
//  Copyright © 2019 SG. All rights reserved.
//

#ifndef SGDispatchMacros_h
#define SGDispatchMacros_h

typedef void(^sg_dispatch_semaphore_signal)(void);
typedef void(^sg_dispatch_async_block)(sg_dispatch_semaphore_signal _Nullable sg_semaphore_signal);

/**
 并发事务操作，可变参数添加多个事务
 
 @param sg_main_completion_handler 所有并发事务完成主线程回调，每个事务处理完事件后需要手动调用sg_semaphore_signal()，不然会一直处于dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)等待中
 @return return value description
 */
static inline void SG_Dispatch_main_completion_handler(void (^ _Nullable sg_main_completion_handler)(void), sg_dispatch_async_block _Nullable block, ...) NS_REQUIRES_NIL_TERMINATION;

static inline void SG_Dispatch_main_completion_handler(void (^ _Nullable sg_main_completion_handler)(void), sg_dispatch_async_block _Nullable block, ...) {
    
    NSMutableArray *block_array = [NSMutableArray array];
    
    va_list argList;
    if (block) {
        [block_array addObject:block];
        va_start(argList, block);
        sg_dispatch_async_block temp_block;
        while ((temp_block = va_arg(argList, sg_dispatch_async_block))) {
            [block_array addObject:temp_block];
        }
        va_end(argList);
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (sg_dispatch_async_block async_block in block_array) {
        dispatch_block_t block_t = ^{
            async_block(^{
                dispatch_semaphore_signal(semaphore);
            });
        };
        dispatch_group_async(group, queue, block_t);
    }
    
    dispatch_group_notify(group, queue, ^{
        for (NSInteger i = 0; i < block_array.count; i ++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (sg_main_completion_handler) sg_main_completion_handler();
        });
    });
}

#endif /* SGDispatchMacros_h */
