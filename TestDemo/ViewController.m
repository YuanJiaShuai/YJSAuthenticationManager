//
//  ViewController.m
//  TestDemo
//
//  Created by yjs on 2019/4/30.
//  Copyright © 2019 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "ViewController.h"
#import "AuthViewController.h"
#import "AuthPopController.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(16, 100, self.view.bounds.size.width - 32, 44)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"解锁" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)button{
    AuthViewController *authVc = [[AuthViewController alloc]init];
    authVc.modalPresentationStyle = UIModalPresentationCustom;
    //presentVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    // 此对象要实现 UIViewControllerTransitioningDelegate 协议
    authVc.transitioningDelegate = self;
    [self presentViewController:authVc animated:YES completion:nil];
}

// delegate-弹出视图代理

// 返回控制控制器弹出动画的对象
/**
 presentedViewController     将要跳转到的目标控制器
 presentingViewController    跳转前的原控制器
 */
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    AuthPopController *authPop = [[AuthPopController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    authPop.dismissBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    return authPop;
}

@end
