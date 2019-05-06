//
//  YJSAuthenticationManager.m
//  TestDemo
//
//  Created by yjs on 2019/5/6.
//  Copyright © 2019 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "YJSAuthenticationManager.h"

@implementation YJSAuthenticationManager

+ (instancetype)sharedInstance{
    static YJSAuthenticationManager * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}

/**
 判断是否支持生物验证
 
 @return 验证结果
 */
- (YJSAuthState)judgeSupportAuth{
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    //判断是否支持指纹识别或者是面部识别
    BOOL support = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    if(support){
        return YJSAuthStateEnable;
    }else{
        switch (error.code) {
            case LAErrorBiometryNotEnrolled:{
                return YJSAuthStateUnEnable;
                break;
            }
            case LAErrorPasscodeNotSet:{
                return YJSAuthStateUnEnable;
                break;
            }
            case LAErrorBiometryLockout:{
                return YJSAuthStateErrorLock;
                break;
            }
            default:{
                return YJSAuthStateUnEnable;
                break;
            }
        }
    }
}

- (void)authentication{
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    //判断是否支持指纹识别或者是面部识别
    BOOL support = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    if(support){
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"开启验证" reply:^(BOOL success, NSError * _Nullable error) {
            
        }];
    }
}

- (void)authenticationWithSuccess:(void(^)(void))successHandle
                             fail:(void(^)(YJSAuthState state))failHandle
                    feedBackTitle:(NSString *)feebBackTitle
                       authPolicy:(LAPolicy)authPolicy{
    LAContext *context = [[LAContext alloc]init];
    context.localizedFallbackTitle = feebBackTitle;
    NSError *error = nil;
    
    //判断是否支持指纹识别或者是面部识别
    BOOL support = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    if(support){
        [context evaluatePolicy:authPolicy localizedReason:@"开启验证" reply:^(BOOL success, NSError * _Nullable error) {
            if(success){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    successHandle();
                }];
            }else{
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateFail);// 身份验证没有成功，因为用户未能提供有效的凭据(连续3次验证失败时提示)
                        }];
                        break;
                    }
                    case LAErrorUserCancel:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateCancel);// 身份验证被用户取消（当用户点击取消按钮时提示）
                        }];
                        break;
                    }
                    case LAErrorUserFallback:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateFeedBack);//（当用户点击输入密码时提示）
                        }];
                        break;
                    }
                    case LAErrorSystemCancel:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateCancel);//身份验证被系统取消（验证时当前APP被移至后台或者点击了home键导致验证退出时提示）
                        }];
                        break;
                    }
                    case LAErrorPasscodeNotSet:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateUnEnable); // Touch ID无法启动，因为错误次数过多
                        }];
                        break;
                    }
                    case LAErrorBiometryNotAvailable:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateUnEnable);// 无法启动身份验证（这种情况没有检测到，应该是出现硬件损坏才会出现）
                        }];
                        break;
                    }
                    case LAErrorBiometryNotEnrolled:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateUnEnable);// 无法启动身份验证，因为触摸没有注册的手指 （这个暂时没检测到）
                        }];
                        break;
                    }
                    case LAErrorBiometryLockout:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateErrorLock);// 错误太多次
                        }];
                        break;
                    }
                    default:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            failHandle(YJSAuthStateUnEnable);//Touch ID没配置
                        }];
                        break;
                    }
                }
            }
        }];
    }else{
        failHandle(YJSAuthStateUnEnable);
    }
}

@end
