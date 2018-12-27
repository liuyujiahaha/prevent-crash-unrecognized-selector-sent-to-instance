//
//  NSObject+AvoidCrash.h
//  crash
//
//  Created by liuyujia on 2018/12/27.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic,copy) NSString * _Nullable crashMsg;

- (void)getCrashMsg;

@end

@interface NSObject (AvoidCrash)

@end

NS_ASSUME_NONNULL_END
