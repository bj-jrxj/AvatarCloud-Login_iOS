# AvatarCloud_Login

[![CI Status](https://img.shields.io/travis/bj-jrxj/AvatarCloudSDK.svg?style=flat)](https://travis-ci.org/bj-jrxj/AvatarCloudSDK)
[![Version](https://img.shields.io/cocoapods/v/AvatarCloudSDK.svg?style=flat)](https://cocoapods.org/pods/AvatarCloudSDK)
[![License](https://img.shields.io/cocoapods/l/AvatarCloudSDK.svg?style=flat)](https://cocoapods.org/pods/AvatarCloudSDK)
[![Platform](https://img.shields.io/cocoapods/p/AvatarCloudSDK.svg?style=flat)](https://cocoapods.org/pods/AvatarCloudSDK)



---
## 介绍

### [云头像平台](https://fc.faceface2.com)

云头像平台提供海量免费原创IP头像，包含卡通、二次元、像素、写实等丰富多元的风格，实现自定义头像、智能生成头像、保存头像等独特功能。

通过与国内知名影视、动画、潮玩等行业头部公司合作，创作出以IP形象为核心的头像，深受用户喜爱。已帮助众多知名央国企平台升级原创IP头像服务。

本平台所使用的头像及美术素材，均已签订协议并获得授权，平台内的头像可直接作为用户头像使用。如需二次编辑或衍生品开发，请联系[**云头像平台**](https://fc.faceface2.com)。



* **具体内测申请流程请访问官网: https://fc.faceface2.com**

|功能模块|平台|下载地址|
|-|-------:|:------:|
|云头像|iOS<br>Adnroid|https://github.com/bj-jrxj/AvatarCloud_iOS<br>https://github.com/bj-jrxj/AvatarCloud_Android|
|云头像+一键登录|iOS|https://github.com/bj-jrxj/AvatarCloud-Login_iOS.git|


---
## 安装


### SDK集成

#### [cocoaPods](https://cocoapods.org) 集成

1.本地项目文件夹下，修改`Podfile`文件

```
platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'App' do
pod 'AvatarCloud_Login'
end
```

2.终端执行命令，加载AvatarCloudSDK
```
pod install
```

3.如果安装失败，请更新cocoapods的资源配置信息
```
pod repo update
```

#### 手动集成
  * 在demo工程路径下的`AvatarCloudSDK.framework`和资源文件`AvatarCloudSDK.bundle`复制到业务工程
  * 在工程的 Other Linker Flags 中添加 -ObjC 参数



---
## 使用

#### 配置

* 配置**clientId** 和 **clientSecret**， `clientId` 和 `clientSecret` 请在[官网](https://fc.faceface2.com)申请

* 在工程的AppDelegate.m文件导入头文件，并初始化

* 在 info.plist 文件中添加一个子项目 App Transport Security Settings，然后在其中添加一个 key：Allow Arbitrary Loads，其值为YES。

```
#import <AvatarCloudSDK/AvatarCloudSDK.h>
    
[AvatarCloudSDKManager initWithClient_id:@"clientId" client_secret:@"clientSecret"];
```

#### 一键登录调用


##### 授权界面
```
#import <AvatarCloudSDK/AvatarCloudSDK.h>


/*
一键登录，获取到的token，可传给移动认证服务端获取完整手机号

@param controller  唤起自定义授权页的容器
@param model 需要配置的Model属性
@param completion 回调
*/
[[ACLoginManager sharedInstance] getAuthorizationWithController:'ViewController' model:'ACLCustomModel' complete:^(id  _Nonnull sender) {
    NSLog(@"custom login %@", sender);
    NSString *code = [sender objectForKey:@"resultCode"];
    if ([ACLoginCodeSuccess isEqualToString:code]) {
        [self authLoginSuccess];
    } else if ([ACLoginCodeClickCancel isEqualToString:code]) {
        weakSelf.bgView.hidden = YES;
        [self authLoginExit];
    } else if ([ACLoginCodeClickChangeBtn isEqualToString:code]) {
        [self authLoginChange];
    }
}];

//取号
[[ACLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull result) {
    NSLog(@"getPhoneNumberCompletion %@", result);
    NSString *resultCode = result[@"resultCode"];
    if ([ACLoginCodeSuccess isEqualToStringresultCode])
    {
        NSLog(@"预取号成功");
    } else {
        NSLog(@"预取号失败");
    }
}];

//关闭授权界面 flag 动画开关
[[ACLoginManager sharedInstance] dismissViewControllerAnimated:YES completion:^{
    weakSelf.bgView.hidden = YES;
}];
```

##### 自定义授权界面
```
ACLCustomModel *customModel = [ACLCustomModel new];

/** 授权页弹出方向，默认ACLPresentationDirectionBottom */
customModel.presentDirection = ACLPresentationDirectionBottom;

/** 授权页customView展现形式 */
customModel.contentViewType = ACLContentViewFullScreen;

/** 自定义logo frmae */
customModel.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
    frame = CGRectMake(100, 100, 80, 80);
    return frame;
};

/** 自定义登录按钮 */
customModel.loginBtnText = [[NSAttributedString alloc] initWithString:@"本机号码一键登录" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:[UIFont systemFontOfSize:15]}];

/** 自定义协议及链接 */
customModel.privacyLinkArray = @[@[@"用户协议", @"https://xxx.com"], @[@"隐私政策", @"https://xxx.com"]];

```

#### 头像调用

```
#import <AvatarCloudSDK/AvatarCloudSDK.h>

//controller:跳转界面容器。 animated:跳转动画
[[AvatarCloudSDKManager sharedInstance] initWithParentController:self animated:YES];

//设置sdk内部头像圆角尺寸
[AvatarCloudSDKManager sharedInstance].cornerRadius = 24;

//默认NO，设置YES时，cornerRadius无效
[AvatarCloudSDKManager sharedInstance].isCircle = NO;

//获取生成的图片，返回对象类型UIImage
[[AvatarCloudSDKManager sharedInstance] getImage:^(UIImage * _Nonnull image) {
    weakSelf.avatarView.image = image;
}];

//获取生成的图片，返回对象类型NSData
[[AvatarCloudSDKManager sharedInstance] getImageData:^(NSData * _Nonnull imageData) {
    weakSelf.avatarView.image = [UIImage imageWithData:imageData];
}];
```

* 更多高级功能配置请参考demo工程相关文档
