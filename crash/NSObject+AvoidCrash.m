//
//  NSObject+AvoidCrash.m
//  crash
//
//  Created by liuyujia on 2018/12/27.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import "NSObject+AvoidCrash.h"
#import <objc/runtime.h>
#import <pthread.h>

@implementation CrashProxy

- (void)getCrashMsg{
    NSLog(@"%@",_crashMsg);
}

@end

@implementation NSObject (AvoidCrash)

//忽略报错
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-protocol-method-implementation"
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    //通过NSString生成选择子SEL
    NSString *methodName = NSStringFromSelector(aSelector);
    
    //类名是否以_开头、UITextInputController、UIKeyboard和dealloc
    if ([NSStringFromClass([self class]) hasPrefix:@"_"] ||
        [self isKindOfClass:NSClassFromString(@"UITextInputController")] ||
        [NSStringFromClass([self class]) hasPrefix:@"UIKeyboard"] ||
        [methodName isEqualToString:@"dealloc"])
    {
        
        return nil;
    }
    
    //代理人类
    CrashProxy * crashProxy = [CrashProxy new];
    
    //描述内容
    crashProxy.crashMsg =[NSString stringWithFormat:@"CrashProtector: [%@ %p %@]: unrecognized selector sent to instance",NSStringFromClass([self class]),self,NSStringFromSelector(aSelector)];
    
    //动态给crashProxy添加方法getCrashMsg
    class_addMethod([CrashProxy class], aSelector, [crashProxy methodForSelector:@selector(getCrashMsg)], "v@:");
    
    return crashProxy;
}
#pragma clang diagnostic pop


@end
