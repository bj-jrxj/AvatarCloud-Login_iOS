//
//  ACCode.h
//  AvatarCloudSDK
//
//  Created by King on 2022/7/7.
//


typedef NS_ENUM (NSUInteger, ACCodeType) {
    ACCodeInitFail          = 50001,        //初始化失败
    ACCodeAppInfoError      = 50002,        //初始化参数错误
    
    ACCodeSuccess           = 60000,        //无错误
    ACCodeNotInit           = 60001,        //没有初始化
    ACCodeContainerInvalid  = 60002,        //容器无效
    ACCodeImageFail         = 60003,        //图片生成失败
    ACCodeTimeOut           = 60004,        //请求超时
    ACCodeNotConnected      = 60005,        //无连接
    
    ACCodeUnknowError       = 60009,        //未知错误
};


/// 成功通用回调
typedef void (^ACBlockSuccess)(void);
/// 失败通用回调
typedef void (^ACBlockError)(ACCodeType codeType, NSString *desc);
