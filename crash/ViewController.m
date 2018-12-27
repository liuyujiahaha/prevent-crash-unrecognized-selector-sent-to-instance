//
//  ViewController.m
//  crash
//
//  Created by liuyujia on 2018/12/26.
//  Copyright © 2018 liuyujia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SEL selector = NSSelectorFromString(@"demo");
    
    //只要导入了NSObject+AvoidCrash文件，就不会出现unrecognized selector sent to instance的问题
    [self performSelector:selector withObject:nil];
}


@end
