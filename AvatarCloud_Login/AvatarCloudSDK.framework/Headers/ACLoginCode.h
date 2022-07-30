//
//  ACLoginCode.h
//  AvatarCloudSDK
//
//  Created by King on 2022/7/29.
//

#ifndef ACLoginCode_h
#define ACLoginCode_h


#import <Foundation/Foundation.h>

typedef NSString* ACLoginCode;

//成功
static NSString* const ACLoginCodeSuccess                = @"103000";
//数据解析异常
static NSString* const ACLoginCodeProcessException       = @"200021";
//无网络
static NSString* const ACLoginCodeNoNetwork              = @"200022";
//请求超时
static NSString* const ACLoginCodeRequestTimeout         = @"200023";
//未知错误
static NSString* const ACLoginCodeUnknownError           = @"200025";
//蜂窝未开启或不稳定
static NSString* const ACLoginCodeNonCellularNetwork     = @"200027";
//网络请求出错(HTTP Code 非200)
static NSString* const ACLoginCodeRequestError           = @"200028";
//非移动网关重定向失败
static NSString* const ACLoginCodeWAPRedirectFailed      = @"200038";
//无SIM卡
static NSString* const ACLoginCodePhoneWithoutSIM        = @"200048";
//Socket创建或发送接收数据失败
static NSString* const ACLoginCodeSocketError            = @"200050";
//用户点击了“账号切换”按钮（自定义短信页面customSMS为YES才会返回）
static NSString* const ACLoginCodeCustomSMSVC            = @"200060";
//显示登录"授权页面"被拦截（hooked）
static NSString* const ACLoginCodeAutoVCisHooked         = @"200061";
//服务端返回数据异常
static NSString* const ACLoginCodeExceptionData          = @"200064";
//CA根证书校验失败
static NSString* const ACLoginCodeCAAuthFailed           = @"200072";
//本机号码校验仅支持移动手机号
static NSString* const ACLoginCodeGetMoblieOnlyCMCC      = @"200080";
//服务器繁忙
static NSString* const ACLoginCodeServerBusy             = @"200082";
//ppLocation为空
static NSString* const ACLoginCodeLocationError          = @"200086";
//监听授权界面成功弹起
static NSString* const ACLoginControllerPresentSuccess   = @"200087";
//监听授权界面成功失败
static NSString* const ACLoginControllerPresentFail      = @"200088";
//当前网络不支持取号
static NSString* const ACLoginCodeUnsupportedNetwork     = @"200096";



// 点击返回，⽤户取消一键登录
static NSString*  const ACLoginCodeClickCancel           = @"300000";
// 点击切换按钮，⽤户取消免密登录
static NSString*  const ACLoginCodeClickChangeBtn        = @"300001";
// 点击登录按钮事件
static NSString*  const ACLoginCodeClickLoginBtn         = @"300002";

#endif /* ACLoginCode_h */
