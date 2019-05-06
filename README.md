# YJSAuthenticationManager
指纹，FaceID识别登录
```
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YJSAuthState) {
    ///验证通过
    YJSAuthStateSuccess = 0,
    ///验证失败
    YJSAuthStateFail = 1,
    ///取消验证
    YJSAuthStateCancel = 2,
    ///验证回退（点击了feedBack 按钮）
    YJSAuthStateFeedBack = 3,
    ///设置不支持生物验证 【1.真的不支持；2.支持但是没有设置】
    YJSAuthStateUnEnable = 4,
    ///设备支持生物验证
    YJSAuthStateEnable = 5,
    ///错误次数过多，被锁定
    YJSAuthStateErrorLock = 6
};

@interface YJSAuthenticationManager : NSObject

/**
 单列
 
 @return instancetype
 */
+ (instancetype)sharedInstance;

/**
 判断是否支持生物验证
 
 @return 验证结果
 */
- (YJSAuthState)judgeSupportAuth;

/**
 简单验证，弹出密码框
 */
- (void)authentication;

/**
 开启验证
 
 @param successHandle 验证成功回掉
 @param failHandle 验证失败回掉
 @param feebBackTitle 失败时返回文本内容
 @param authPolicy 失败时返回文本内容
 */
- (void)authenticationWithSuccess:(void(^)(void))successHandle
                             fail:(void(^)(YJSAuthState state))failHandle
                    feedBackTitle:(NSString *)feebBackTitle
                       authPolicy:(LAPolicy)authPolicy;

@end

NS_ASSUME_NONNULL_END
```
