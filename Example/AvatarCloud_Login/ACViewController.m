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

@interface ACViewController () <AvatarCloudListener>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) ACLCustomModel *customModel;
@property (nonatomic, strong) ACLCustomModel *modelWindow;

@end

@implementation ACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AvatarCloudSDKManager sharedInstance] addAvatarCloudListener:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.backButtonTitle = @"";
    } else {
        // Fallback on earlier versions
    }
        
    self.navigationController.navigationBarHidden = NO;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(37, 88, 240, 145)];
    self.imageView.image = [UIImage imageNamed:@"touxiang_bg"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    CGFloat avatarWidth = ScreenWidth - 110 * 2;
    
    self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(110., 300, avatarWidth, avatarWidth)];
    self.avatarView.layer.cornerRadius = 24;
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.userInteractionEnabled = YES;
    self.avatarView.backgroundColor = [UIColor colorWithRed:244/255. green:244/255. blue:244/255. alpha:1.];
    self.avatarView.image = [UIImage imageNamed:@"touxiang"];
    [self.view addSubview:self.avatarView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar)];
    [self.avatarView addGestureRecognizer:gesture];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300 + avatarWidth + 5, ScreenWidth, 20)];
    infoLabel.text = @"点击更换头像";
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor lightGrayColor];
    infoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:infoLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 550, ScreenWidth - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:244/255. green:244/255. blue:244/255. alpha:1.];
    [self.view addSubview:lineView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 600, ScreenWidth - 40, 50);
    button.layer.cornerRadius = 12.;
    button.layer.masksToBounds = YES;
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.backgroundColor = [UIColor colorWithRed:17/255. green:17/255. blue:17/255. alpha:1.];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)login:(UIButton *)button
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
    
    ACLCustomModel *model = self.customModel;
    
#if 1
    model = self.modelWindow;
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0. alpha:0.2];
    self.bgView = view;
#endif
    
    __weak typeof(self)weakSelf = self;
    [[ACLoginManager sharedInstance] getAuthorizationWithController:self model:model complete:^(id  _Nonnull sender) {
        NSLog(@"custom login %@", sender);
        NSString *code = [sender objectForKey:@"resultCode"];
        if ([ACLoginControllerPresentSuccess isEqualToString:code]) {
            [self.view addSubview:self.bgView];
        } else if ([ACLoginCodeSuccess isEqualToString:code]) {
            [weakSelf authLoginSuccess];
        } else if ([ACLoginCodeClickCancel isEqualToString:code]) {
            [weakSelf authLoginExit];
        } else if ([ACLoginCodeClickChangeBtn isEqualToString:code]) {
            [weakSelf authLoginChange];
        } else {
            [weakSelf removeBgView];
        }
    }];
}


#pragma mark - Login

- (ACLCustomModel *)customModel
{
    if (!_customModel) {
        _customModel = [[ACLCustomModel alloc] init];
        
        _customModel.backBtnImage = [UIImage imageNamed:@"back_ic"];
        _customModel.backBtnIsHidden = NO;
        
//        _modelNew.logoImage = [UIImage imageNamed:@""];
        _customModel.logoIsHidden = NO;
        _customModel.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake((ScreenWidth - 80) / 2., 80, 80, 80);
            return frame;
        };
        
        _customModel.sloganText = [[NSAttributedString alloc] initWithString:@"你好，欢迎来到云头像！" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor] ,NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        _customModel.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = 288;
            return frame;
        };
        
        _customModel.numberOffsetY = 220;
        _customModel.numberColor = [UIColor blackColor];
        _customModel.numberFont = [UIFont systemFontOfSize:28];
        
        _customModel.loginBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        _customModel.loginBtnBgImgs = @[[UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"]];
        _customModel.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(16, superViewSize.height - 300, superViewSize.width - 16 * 2, 56.);
            return frame;
        };
        
        _customModel.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换帐号" attributes:@{NSForegroundColorAttributeName : [UIColor systemBlueColor] ,NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        _customModel.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = superViewSize.height - 200;
            return frame;
        };
        
        _customModel.checkBoxImages = @[[UIImage imageNamed:@"ic_ysxy_off"], [UIImage imageNamed:@"ic_ysxy_on"]];
        _customModel.checkBoxWH = 14;
        _customModel.checkTipText = @"请同意隐私协议";
        
        _customModel.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(50, superViewSize.height - 100, superViewSize.width - 100, 44);
            return frame;
        };
        _customModel.privacyFont = [UIFont systemFontOfSize:13];
        _customModel.privacyPreText = @"登录即表示同意";
        _customModel.privacyColors = @[[UIColor grayColor], [UIColor blackColor]];
        _customModel.privacyLinkArray = @[@[@"用户协议", @"https://fc.faceface2.com"], @[@"隐私政策", @"https://fc.faceface2.com"]];
        _customModel.webNavBackImage = [UIImage imageNamed:@"back_ic"];

    }
    return _customModel;
}


- (ACLCustomModel *)modelWindow
{
    if (!_modelWindow) {
        _modelWindow = [[ACLCustomModel alloc] init];
        
        _modelWindow.contentViewType = ACLContentViewWindow;
        _modelWindow.contentViewSize = CGSizeMake(ScreenWidth, ScreenWidth);
        _modelWindow.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        _modelWindow.backBtnImage = [UIImage imageNamed:@"back_ic"];
        _modelWindow.backBtnIsHidden = NO;
        
        _modelWindow.logoIsHidden = NO;
        _modelWindow.logoImage = [UIImage imageNamed:@"ic_slogan"];
        _modelWindow.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake((superViewSize.width - ScreenWidth * 0.5) / 2., 60, ScreenWidth * 0.5, 20);
            return frame;
        };
        
        _modelWindow.sloganText = [[NSAttributedString alloc] initWithString:@"云头像登录" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor] ,NSFontAttributeName : [UIFont systemFontOfSize:22]}];
        _modelWindow.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame.origin.y = 30;
            return frame;
        };
        
        _modelWindow.numberOffsetY = 130;
        _modelWindow.numberColor = [UIColor blackColor];
        _modelWindow.numberFont = [UIFont systemFontOfSize:28];
        
        _modelWindow.loginBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        _modelWindow.loginBtnBgImgs = @[[UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"], [UIImage imageNamed:@"btn_login_one_click_bg"]];
        _modelWindow.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(50, 200, superViewSize.width - 50 * 2, 56.);
            return frame;
        };
        
        _modelWindow.changeBtnIsHidden = YES;
        
        __weak typeof(self)weakSelf = self;
        _modelWindow.customViewBlock = ^(UIView * _Nonnull superCustomView) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 300, 100, 40)];
            label.text = @"其他方式登录:";
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            [superCustomView addSubview:label];
            
            UIButton *otherLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            otherLoginButton.frame = CGRectMake(150, 300, 40, 40);
            otherLoginButton.layer.cornerRadius = otherLoginButton.frame.size.height / 2.;
            otherLoginButton.backgroundColor = [UIColor lightGrayColor];
            [otherLoginButton setTitle:@"A" forState:UIControlStateNormal];
            [otherLoginButton addTarget:weakSelf action:@selector(clickOtherButton:) forControlEvents:UIControlEventTouchUpInside];
            [superCustomView addSubview:otherLoginButton];
        };
        
        _modelWindow.checkBoxImages = @[[UIImage imageNamed:@"ic_ysxy_off"], [UIImage imageNamed:@"ic_ysxy_on"]];
        _modelWindow.checkBoxWH = 14;
        
        _modelWindow.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
            frame = CGRectMake(50, superViewSize.height - 100, screenSize.width - 100, 44);
            return frame;
        };
        _modelWindow.privacyFont = [UIFont systemFontOfSize:13];
        _modelWindow.privacyPreText = @"登录即表示同意";
        _modelWindow.privacyColors = @[[UIColor grayColor], [UIColor blackColor]];
        _modelWindow.privacyLinkArray = @[@[@"用户协议", @"https://baidu.com"], @[@"隐私政策", @"https://baidu.com"]];
        _modelWindow.webNavBackImage = [UIImage imageNamed:@"back_ic"];
    }
    return _modelWindow;
}

- (void)clickOtherButton:(UIButton *)button
{
    NSLog(@"other login");
}

- (void)authLoginExit
{
    [self removeBgView];
}

- (void)authLoginChange
{
    [self removeBgView];
    [[ACLoginManager sharedInstance] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)authLoginSuccess
{
    [self removeBgView];
    [[ACLoginManager sharedInstance] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)removeBgView
{
    if (self.bgView) {
        [self.bgView removeFromSuperview];
    }
}

#pragma mark - Avatar

- (void)clickAvatar
{
    __weak typeof(self) weakSelf = self;
    AvatarCloudSDKManager *avatarCloudSDKManager = [AvatarCloudSDKManager sharedInstance];
    [avatarCloudSDKManager initWithParentController:self animated:YES];
//    avatarCloudSDKManager.isCircle = YES;
    [[AvatarCloudSDKManager sharedInstance] getImage:^(UIImage * _Nonnull image) {
        weakSelf.avatarView.image = image;
    }];
//    [[AvatarCloudSDKManager sharedInstance] getImageData:^(NSData * _Nonnull imageData) {
//        weakSelf.avatarView.image = [UIImage imageWithData:imageData];
//    }];
}

- (void)avatarCloudError:(NSDictionary *)resultDic
{
    NSLog(@"avatarCloudError %@", resultDic);
}

- (void)dealloc
{
    [[AvatarCloudSDKManager sharedInstance] removeAvatarCloudListener];
}

@end
