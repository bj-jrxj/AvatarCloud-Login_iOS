//
//  ACViewController.m
//  AvatarCloud_Login
//
//  Created by cyssan1991 on 07/30/2022.
//  Copyright (c) 2022 cyssan1991. All rights reserved.
//

#import "ACViewController.h"
#import <AvatarCloudSDK/AvatarCloudSDK.h>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ACViewController ()

@property (nonatomic, strong) ACLCustomModel *modelNew;
@property (nonatomic, strong) ACLCustomModel *modelNewWindow;
@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation ACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 200) / 2., 100, 200, 200)];
    avatarImageView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:avatarImageView];
    self.avatarView = avatarImageView;
    avatarImageView.userInteractionEnabled = YES;
    [avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake((ScreenWidth - 200) / 2., 400, 200, 44);
    loginButton.backgroundColor = [UIColor blackColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)clickImage:(UIGestureRecognizer *)gesture
{
    [[AvatarCloudSDKManager sharedInstance] initWithParentController:self animated:YES];
    [[AvatarCloudSDKManager sharedInstance] getImage:^(UIImage * _Nonnull image) {
        self.avatarView.image = image;
    }];
}

- (void)clickButton:(UIButton *)button
{
    [[ACLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull result) {
        NSLog(@"getPhoneNumberCompletion %@", result);
        NSString *resultCode = result[@"resultCode"];
        if ([ACLoginCodeSuccess isEqualToString:resultCode])
        {
            NSLog(@"预取号成功");
        } else {
            NSLog(@"预取号失败");
        }
    }];
    
    
    ACLCustomModel *austomModel = [ACLCustomModel new];
//    austomModel = self.modelNew;
//    austomModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscapeRight;
//    [austomModel setCustomViewBlock:^(UIView * _Nonnull superCustomView) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(superCustomView.width - 44, 10, 20, 20)];
//        view.backgroundColor = [UIColor redColor];
//        [superCustomView addSubview:view];
//    }];
    [austomModel setCustomViewLayoutBlock:^(CGSize screenSize, CGRect contentViewFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        
    }];
    
    __weak typeof(self)weakSelf = self;
    [[ACLoginManager sharedInstance] getAuthorizationWithController:self model:austomModel complete:^(id  _Nonnull sender) {
        NSLog(@"custom login %@", sender);
        NSString *code = [sender objectForKey:@"resultCode"];
        if ([ACLoginCodeSuccess isEqualToString:code]) {
            [self authLoginSuccess];
        } else if ([ACLoginCodeClickCancel isEqualToString:code]) {
            [self authLoginExit];
        } else if ([ACLoginCodeClickChangeBtn isEqualToString:code]) {
            [self authLoginChange];
        }
    }];
}


//------

- (ACLCustomModel *)modelNew
{
    if (!_modelNew) {
        _modelNew = [[ACLCustomModel alloc] init];
        _modelNew.navBackImage = [UIImage imageNamed:@""];
        _modelNew.hideNavBackBtn = NO;
        _modelNew.webNavBackImage = [UIImage imageNamed:@"ic_back_arrow"];
        _modelNew.logoImage = [UIImage imageNamed:@"ic_slogan"];
        _modelNew.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake((ScreenWidth - 323) / 2., 88, 323, 31);
            return frame;
        };
        
        _modelNew.logoIsHidden = NO;
        _modelNew.sloganText = [[NSAttributedString alloc] initWithString:@"你好，欢迎来到交往！" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor] ,NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        _modelNew.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = 288;
            return frame;
        };
        _modelNew.numberOffsetY = 220;
        _modelNew.numberColor = [UIColor blackColor];
        _modelNew.numberFont = [UIFont systemFontOfSize:28];
        
        _modelNew.loginBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        _modelNew.loginBtnBgImgs = @[[UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"]];
        _modelNew.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(16, ScreenHeight - 300, superViewSize.width - 16 * 2, 56.);
            return frame;
        };
        
        _modelNew.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换帐号" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor] ,NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        _modelNew.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = ScreenHeight - 200;
            return frame;
        };
        
        _modelNew.checkBoxImages = @[[UIImage imageNamed:@"ic_ysxy_off"], [UIImage imageNamed:@"ic_ysxy_on"]];
        _modelNew.checkBoxWH = 14;
        
        _modelNew.privacyFont = [UIFont systemFontOfSize:13];
        _modelNew.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(50, ScreenHeight - 200, screenSize.width - 100, 44);
            return frame;
        };
        
        _modelNew.privacyPreText = @"登录即表示同意";
        _modelNew.privacyColors = @[[UIColor grayColor], [UIColor blackColor]];
        _modelNew.privacyLinkArray = @[@[@"用户协议", @"https://baidu.com"], @[@"隐私政策", @"https://baidu.com"]];
    }
    return _modelNew;
}


- (ACLCustomModel *)modelNewWindow
{
    if (!_modelNewWindow) {
        _modelNewWindow = [[ACLCustomModel alloc] init];
        
        _modelNewWindow.contentViewType = 1;
        _modelNewWindow.contentViewSize = CGSizeMake(ScreenWidth, ScreenWidth);
        _modelNewWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _modelNewWindow.navBackImage = [UIImage imageNamed:@""];
        _modelNewWindow.hideNavBackBtn = NO;
        _modelNewWindow.webNavBackImage = [UIImage imageNamed:@"ic_back_arrow"];
        
        _modelNewWindow.logoIsHidden = NO;
        _modelNewWindow.logoImage = [UIImage imageNamed:@"ic_slogan"];
        _modelNewWindow.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake((superViewSize.width - ScreenWidth * 0.5) / 2., 60, ScreenWidth * 0.5, 20);
            return frame;
        };
        
        _modelNewWindow.sloganText = [[NSAttributedString alloc] initWithString:@"你好，欢迎来到交往！" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor] ,NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        _modelNewWindow.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = 150;
            return frame;
        };
        _modelNewWindow.numberOffsetY = 100;
        _modelNewWindow.numberColor = [UIColor blackColor];
        _modelNewWindow.numberFont = [UIFont systemFontOfSize:28];
        
        _modelNewWindow.loginBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        _modelNewWindow.loginBtnBgImgs = @[[UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"]];
        _modelNewWindow.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(16, 200, superViewSize.width - 16 * 2, 56.);
            return frame;
        };
        
        _modelNewWindow.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换帐号" attributes:@{NSForegroundColorAttributeName : [UIColor blueColor] ,NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        _modelNewWindow.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = superViewSize.height - 100;
            return frame;
        };
        
        _modelNewWindow.checkBoxImages = @[[UIImage imageNamed:@"ic_ysxy_off"], [UIImage imageNamed:@"ic_ysxy_on"]];
        _modelNewWindow.checkBoxWH = 14;
        _modelNewWindow.privacyFont = [UIFont systemFontOfSize:13];
        _modelNewWindow.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(50, superViewSize.height - 100, screenSize.width - 100, 44);
            return frame;
        };
        
        _modelNewWindow.privacyPreText = @"登录即表示同意";
        _modelNewWindow.privacyColors = @[[UIColor grayColor], [UIColor blackColor]];
        _modelNewWindow.privacyLinkArray = @[@[@"用户协议", @"https://baidu.com"], @[@"隐私政策", @"https://baidu.com"]];
    }
    return _modelNewWindow;
}

- (void)authLoginExit
{
    
}

- (void)authLoginChange
{
    [[ACLoginManager sharedInstance] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)authLoginSuccess
{
    [[ACLoginManager sharedInstance] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
