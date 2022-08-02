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
|-|-------:|:------|
|云头像|iOS<br>Adnroid|https://github.com/bj-jrxj/AvatarCloud_iOS<br>https://github.com/bj-jrxj/AvatarCloud_Android|
|云头像+一键登录|iOS<br>Adnroid|https://github.com/bj-jrxj/AvatarCloud-Login_iOS<br>https://github.com/bj-jrxj/AvatarCloud_Android/blob/main/README16.md|



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

#### 初始化

```
#import <AvatarCloudSDK/AvatarCloudSDK.h>
    
[AvatarCloudSDKManager initWithClient_id:@"clientId" client_secret:@"clientSecret"];
```

### 一键登录功能

> #### 取号请求

本方法用于发起取号请求，SDK 完成网络判断、蜂窝数据网络切换等操作并缓存凭证 scrip。
```
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

```


> #### 授权请求

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

//关闭授权界面 flag 动画开关
[[ACLoginManager sharedInstance] dismissViewControllerAnimated:YES completion:^{
    weakSelf.bgView.hidden = YES;
}];
```

##### 授权响应参数:

字段 | 类型 | 含义
--- | :--- | :---
resultCode |  NSString | 接口返回码。 具体返回码见  SDK 返回码
desc |  NSString | 返回描述
token | NSString | 成功时返回:临时凭证，token 有效期 2min，一次有效;同一 用户(手机号)10 分钟内获取 token 且未使用的数量不超过 30个
operatorType | NSString | 运营商类型
scripExpiresIn | NSString | 成功时返回。表示 scrip 有效期，单位：秒。注：仅移动号码返回，电信联通在这里不会生成缓存，scripExpiresIn=0
tokenExpiresIn | NSString | 成功时返回。表示 token 有效期，单位：秒
traceId | NSString | 用于定位 SDK 问题



> #### 自定义授权界面

为了确保用户在登录过程中将手机号码信息授权给开发者使用的知情权，一键登 录需要开发者提供授权页登录页面供用户授权确认。开发者在调用授权登录方法前，必须弹出授权页，明确告知用户当前操作会将用户的本机号码信息传递给应用。
1、开发者不得通过任何技术手段，破解授权页，或将授权页面的号码栏、隐私 栏、品牌露出内容隐藏、覆盖。
2、登录按钮文字描述必须包含“登录”或“注册”等文字，不得诱导用户授权。
3、对于接入移动认证 SDK 并上线的应用，我方会对上线的应用授权页面做审查， 如果有出现未按要求弹出或设计授权页面的，将关闭应用的认证取号服务。

##### 自定义model
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

/** 自定义控件添加 */
[austomModel setCustomViewBlock:^(UIView * _Nonnull superCustomView) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(superCustomView.width - 44, 10, 20, 20)];
    view.backgroundColor = [UIColor redColor];
    [superCustomView addSubview:view];
}];

```


##### ACLCustomModel 配置元素说明:

属性 | 类型 | 说明
--- | :--- | :---
customViewBlock | UIView *superCustomView | 设置授权页自定义控件添加
presentDirection | ACLPresentationDirection | 授权页面推出动画效果
isPresentAnimated | BOOL | 授权页面是否需要弹出动画，默认为YES
contentViewType | ACLContentViewType | customView 展现形式。0默认全屏，1弹窗（屏幕居中），2底部弹窗
返回按钮  
navBackImage | UIImage | 导航栏返回图片 
hideNavBackBtn | BOOL | 是否隐藏授权页返回按钮，默认不隐藏
backBtnFrameBlock | ACLBuildFrameBlock | return frame; 构建返回按钮的的frame
logo
logoImage | UIImage | 设置一张图片
logoIsHidden | BOOL | 是否隐藏授权页logo，默认不隐藏
logoFrameBlock | ACLBuildFrameBlock | return frame; 构建logo图片的的frame
slogan 
sloganText | NSAttributedString | 设置slogan的富文本属性（字体大小、颜色、文案内容）
sloganIsHidden | BOOL | 是否隐藏授权页slogan，默认不隐藏
sloganFrameBlock | ACLBuildFrameBlock | return frame; 构建slogan的的frame
号码 
numberColor | UIColor | 号码颜色
numberFont | UIFont | 号码字体大小设置，大小小于16则不生效
numberOffsetY | CGFloat | 号码相对contengView顶部的Y轴距离，不设置则按默认处理
numberOffsetX | CGFloat | 号码相对屏幕中线的X轴偏移距离，不设置则按默认处理，默认为0水平居中
登录 
loginBtnText | NSAttributedString | 设置登录按钮的富文本属性（字体大小、颜色、文案内容）
loginBtnBgImgs | NSArray | 设置授权登录按钮三种状态的图片数组，数组顺序为：[0]激活状态的图片；[1] 失效状态的图片；[2] 高亮状态的图片
loginBtnFrameBlock | ACLBuildFrameBlock | return frame; 构建登录按钮的frame
切换按钮
changeBtnTitle | NSAttributedString | 设置切换按钮的富文本属性（字体大小、颜色、文案内容）
changeBtnIsHidden | BOOL | 是否隐藏授权页切换按钮，默认不隐藏
changeBtnFrameBlock | ACLBuildFrameBlock | return frame; 构建切换按钮的frame
协议
checkBoxImages | NSArray | checkBox图片组，[uncheckedImg,checkedImg]
checkBoxIsChecked | BOOL | checkBox是否勾选，默认NO
checkBoxWH | CGFloat | 复选框大小（只能正方形）必须大于12
privacySymbol | BOOL | 隐私条款默认协议是否开启书名号
privacyLinkArray | NSArray | [ [协议名称,协议Url]，[协议名称,协议Url], ...] 注：协议名称不能相同
privacyColors | NSArray | 协议内容颜色数组，[非点击文案颜色，点击文案颜色]
privacyPreText | NSString | 协议整体文案，前缀部分文案
privacySufText | NSString | 协议整体文案，后缀部分文案
privacyFont | UIFont | 协议整体文案字体大小，小于12.0不生效
privacyFrameBlock | ACLBuildFrameBlock | return frame; 构建协议整体的frame
checkTipText | NSString | 默认文案：“请勾选登录协议”，如果为空，则点击时无提示。该属性被合法赋值（非空，且最大长度为100的字符串。
webNavBackImage | UIImage | web协议界面导航栏返回图片
webNavColor | UIColor | web协议界面导航标题栏颜色
webNavTitleAttrs | NSDictionary | web协议界面导航标题字体属性设置 默认值：@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16]}


##### 返回码说明

返回码 | 返回码描述
--- | :---
103000 | 成功
103101 | 请求签名错误(若发生在客户端，可能是 appkey 传错，可检查是否跟 appsecret 弄混，或者有空格。若发生在服务端接口，需要检查验签方 式是 MD5 还是 RSA，如果是 MD5，则排查 signType 字段，若为 appsecret，需确认是否误用了 appkey 生签。如果是 RSA，需要检查使 用的私钥跟报备的公钥是否对应和报文拼接是否符合文档要求。)
103102 | 包签名错误(社区填写的 appid 和对应的包名包签名必须一致)
103111 | 网关 IP 错误(检查是否开了 vpn 或者境外 ip)
103119 | appid 不存在(检查传的 appid 是否正确或是否有空格)
103211 | 其他错误，(常见于报文格式不对，先请检查是否符合这三个要求: a、json 形式的报文交互必须是标准的 json 格式;b、发送时请设置 content type 为 application/json;c、参数类型都是 String。如有需要请 联系 qq 群 609994083 内的移动认证开发)
103902 | scrip 失效(客户端高频调用请求 token 接口)
103911 | token 请求过于频繁，10 分钟内获取 token 且未使用的数量不超过 30 个
103273 | 预取号联通重定向
105002 | 移动取号失败(一般是物联网卡)
105003 | 电信取号失败
105021 | 当天已达取号限额
105302 | appid 不在白名单
105313 | 非法请求
200020 | 取消登录
200021 | 数据解析异常(一般是卡欠费)
200022 | 无网络
200023 | 请求超时
200025 | 其他错误(socket、系统未授权数据蜂窝权限等，如需要协助，请加 入 qq 群发问)
200027 | 未开启数据网络或网络不稳定
200028 | 网络异常
200038 | 异网取号网络请求失败
200048 | 用户未安装 sim 卡
200050 | EOF 异常
200061 | 授权页面异常
200064 | 服务端返回数据异常
200072 | CA 根证书校验失败
200080 | 本机号码校验仅支持移动手机号
200082 | 服务器繁忙
200086 | ppLocation 为空
200087 | 授权页成功调起
200096 | 当前网络不支持取号
300000 | 点击返回，⽤户取消一键登录
300001 | 点击切换按钮，⽤户取消免密登录
300002 | 点击登录按钮事件

> #### 常见问题

##### 产品简介
* + 1 一键登录与本机号码校验的区别?  
    一键登录有授权页面，开发者经用户授权后可获得号码，适用于注
    册/登录场景;本机号码校验不返回号码，仅返回待校验号码是否
    本机的校验结果，适用于所有基于手机号码进行风控的场景。
* + 2 一键登录支持哪些运营商?  
    一键登录目前支持移动、联通、电信三网运营商
* + 3 移动认证是否支持小程序和 H5?  
    支持，具体可咨询移动认证运营或商务人员
* + 4 移动认证对于携号转网的号码，是否还能使用?  
    移动认证SD不提供判断用户是否为携号转网的Api，但提供判断 用户当前流量卡运营商的方法。即携号转网的用户仍然能够使用移 动认证
* + 5 移动认证的原理?
    通过运营商数据网关获取当前流量卡的号码
* + 6 一键登录是否支持多语言?  
    支持中文简体、中文繁体和英文的授权页面(条款暂时只支持中文
    简体)
* + 7 一键登录是否具备用户取号频次限制?  
    对获取token的频次有限制，同一用户(手机号)10分钟内获取 token 且未使用的数量不超过 30 个

##### 能力申请
* + 1 注册邮件无法激活  
    由于各公司企业邮箱的限制，请尽量不使用企业邮箱注册，更换其 他邮箱尝试;
* + 2 服务器 IP 白名单填写有没有要求?
    业务侧服务器接口到移动认证接口访问时，会校验请求服务器的
    IP 地址，防止业务侧用户信息被盗用风险。IP 白名单目前同时支
    持 IPv4 和 IPv6，支持最大 4000 字符，并支持配置 IP 段。
* + 3 安卓和苹果能否使用一个 AppID?  
    需分开创建appid
* + 4. 包签名修改问题?  
       包名和包签名提交后不支持修改，建议直接新建应用
* + 5 包签名不一致会有哪些影响?
    SDK会无法使用

##### SDK 使用问题:
* + 1 最新的移动服务条款在哪里查询?  
    最新的授权条款请见:https://wap.cmpassport.com/resources/html/contract.html
* + 2 用户点击授权后，授权页会自动关闭吗?
    不能，需要开发者调用一下dissmiss，详情见【finish授权页】章节
* + 3 同一个 token 可以多次获取手机号码吗?  
    token是单次有效的，一个token最多只能获取一次手机号。
* + 4 如何判断调用方法是否成功?  
    方法调用后SDK会给出返回码，103000为成功，其余为调用失败。 建议应用捕捉这些返回码，可用于日常数据分析。
* + 5 能力余量不足的问题?  
    确定有充值的情况下，开放平台数据同步至认证SDK系统有约30分钟的延迟时间。
 

---
### 头像功能

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
