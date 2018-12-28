# prevent-crash-unrecognized-selector-sent-to-instance

#### *注意
本项目仅介绍了一种方式，另外一个种方式可查看[https://www.jianshu.com/p/b7a7ae0c9243]（原理大概为：动态替换了NSObject的forwardInvocation和methodSignatureForSelector的方法，内部try catch防止奔溃）。


#### 使用方法

项目中导入了NSObject+AvoidCrash文件后，就再不会出现unrecognized selector sent to instance的问题。

#### 原理

通过实现消息转发，重写- (id)forwardingTargetForSelector:(SEL)aSelector方法，通过runtime动态添加方法。

```
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
```
