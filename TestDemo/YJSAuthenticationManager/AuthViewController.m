//
//  AuthViewController.m
//  TestDemo
//
//  Created by yjs on 2019/4/30.
//  Copyright © 2019 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "AuthViewController.h"
#import "YJSAuthenticationManager.h"

@interface AuthViewController ()

@property (strong, nonatomic) UIImageView *loginImg;
@property (strong, nonatomic) UIButton *loginTipBtn;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customView];
    
    UIEdgeInsets insets = self.view.safeAreaInsets;
    [self authLockIsiPhone:insets.bottom > 0 ? YES : NO];
}

//判断是否是全面屏
- (void)authLockIsiPhone:(BOOL)isiPhone{
    YJSAuthState authState = [[YJSAuthenticationManager sharedInstance] judgeSupportAuth];
    switch (authState) {
        case YJSAuthStateEnable:{
            if(!isiPhone){
                [self.loginTipBtn setTitle:@"指纹登录中..." forState:UIControlStateNormal];
                [self.loginImg setImage:[UIImage imageNamed:@"ic_zhiwen"]];
            }else{
                [self.loginTipBtn setTitle:@"FaceID登录中..." forState:UIControlStateNormal];
                [self.loginImg setImage:[UIImage imageNamed:@"ic_shualian"]];
            }
            
            //是否已经开启过指纹登录【并不是设备是否支持指纹登录，而是是否打开指纹登录这个功能，以后登录不用输入帐号密码直接指纹验证的】
            BOOL isOpenAuth = [[NSUserDefaults standardUserDefaults] boolForKey:@"isOpenAuth"];
            if(isOpenAuth){
                [[YJSAuthenticationManager sharedInstance] authenticationWithSuccess:^{
                    //认证成功
                } fail:^(YJSAuthState state) {
                    if(!isiPhone){
                        [self.loginTipBtn setTitle:@"点击指纹登录" forState:UIControlStateNormal];
                        [self.loginImg setImage:[UIImage imageNamed:@"ic_zhiwen"]];
                    }else{
                        [self.loginTipBtn setTitle:@"点击指纹登录FaceID登录." forState:UIControlStateNormal];
                        [self.loginImg setImage:[UIImage imageNamed:@"ic_shualian"]];
                    }
                    //认证失败
                    if(state == YJSAuthStateFeedBack){
                        //输入密码[显示输入密码的界面]
                    }else if(state == YJSAuthStateErrorLock){
                        //错误次数过多，被锁定
                        [[YJSAuthenticationManager sharedInstance] authentication];
                    }else if(state == YJSAuthStateFail){
                        //第一次错误次数过多，提示用户，第二次提示错误次数过多会锁定
                        NSLog(@"校验错误次数过多，请重试");
                    }
                } feedBackTitle:@"再试一次" authPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
            }else{
                [[YJSAuthenticationManager sharedInstance] authenticationWithSuccess:^{
                    //认证成功
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOpenAuth"];
                } fail:^(YJSAuthState state) {
                    //认证失败
                    if(!isiPhone){
                        [self.loginTipBtn setTitle:@"点击指纹登录" forState:UIControlStateNormal];
                        [self.loginImg setImage:[UIImage imageNamed:@"ic_zhiwen"]];
                    }else{
                        [self.loginTipBtn setTitle:@"点击指纹登录FaceID登录." forState:UIControlStateNormal];
                        [self.loginImg setImage:[UIImage imageNamed:@"ic_shualian"]];
                    }
                } feedBackTitle:@"" authPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
            }
            break;
        }
        case YJSAuthStateUnEnable:{
            //不支持生物验证
            break;
        }
        case YJSAuthStateErrorLock:{
            //                    //支持生物验证 但是识别被锁定了
            //                    self.authView.hidden = YES;
            //                    [self.passwordTF becomeFirstResponder];
            //                    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 270);
            //
            //                    [QMUITips showInfo:@"识别错误次数过多,本次登录需要密码登录"];
            break;
        }
        default:
            break;
    }
}

- (UIImageView *)loginImg{
    if(!_loginImg){
        _loginImg = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 56)/2, 74, 56, 56)];
        _loginImg.image = [UIImage imageNamed:@"ic_zhiwen"];
    }
    return _loginImg;
}

- (UIButton *)loginTipBtn{
    if(!_loginTipBtn){
        _loginTipBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loginImg.frame) + 20, self.view.bounds.size.width, 40)];
        _loginTipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginTipBtn setTitle:@"点击指纹登录" forState:UIControlStateNormal];
        [_loginTipBtn setTitleColor:[UIColor colorWithRed:72.0/255.0 green:84.0/255.0 blue:106.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_loginTipBtn addTarget:self action:@selector(loginTipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginTipBtn;
}

- (void)customView {
    [self.view addSubview:self.loginImg];
    [self.view addSubview:self.loginTipBtn];
}

- (void)loginTipButtonAction:(UIButton *)sender{
    UIEdgeInsets insets = self.view.safeAreaInsets;
    
    [self authLockIsiPhone:insets.bottom > 0 ? YES : NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
