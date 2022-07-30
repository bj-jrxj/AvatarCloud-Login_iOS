//
//  ACLoginManager.h
//  AvatarCloudSDK
//
//  Created by King on 2022/7/23.
//

#import <Foundation/Foundation.h>
#import <AvatarCloudSDK/ACLCustomModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACLoginManager : NSObject

/**
 单例管理
 */
+ (nonnull instancetype)sharedInstance;

/**
 一键登录，获取到的token，可传给移动认证服务端获取完整手机号
 
 @param controller  唤起自定义授权页的容器
 @param model 需要配置的Model属性
 @param completion 回调
 */
- (void)getAuthorizationWithController:(UIViewController *)controller model:(ACLCustomModel *)model complete:(void(^)(id sender))completion;

/**
 取号
 */
- (void)getPhoneNumberCompletion:(void(^)(NSDictionary *_Nonnull result))completion;

/**
 关闭授权界面
 @param flag 动画开关
 */
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

/**
 网络类型及运营商（双卡下，获取上网卡的运营商）
 "carrier"     运营商： 0.未知 / 1.中国移动 / 2.中国联通 / 3.中国电信
 "networkType" 网络类型： 0.无网络/ 1.数据流量 / 2.wifi / 3.数据+wifi
 @return  @{NSString : NSNumber}
 */
- (NSDictionary *)networkInfo;

/**
 设置超时

 @param timeout 超时时间
 */
- (void)setTimeoutInterval:(NSTimeInterval)timeout;

/**
 获取本机号码校验token
 */
- (void)mobileAuthCompletion:(void(^)(NSDictionary *_Nonnull result))completion;

/**
 删除取号缓存数据 + 重置网络开关（自定义按钮事件里dimiss授权界面需调用）
 
 @return YES：有缓存已执行删除操作，NO：无缓存不执行删除操作
 */
- (BOOL)delectScrip;

/**
 控制台日志输出控制（默认关闭）
 
 @param enable 开关参数
 */
- (void)printConsoleEnable:(BOOL)enable;


@end

NS_ASSUME_NONNULL_END
