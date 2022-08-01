//
//  ACLCustomModel.h
//  AvatarCloudSDK
//
//  Created by King on 2022/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ACLPresentationDirection){
    ACLPresentationDirectionBottom = 0,
    ACLPresentationDirectionRight,
    ACLPresentationDirectionTop,
    ACLPresentationDirectionLeft,
};

typedef NS_ENUM(NSUInteger, ACLContentViewType) {
    ACLContentViewFullScreen = 0,
    ACLContentViewWindow,
    ACLContentViewSheet,
};


/**
 *  构建控件的frame，view布局时会调用该block得到控件的frame
 *  @param  screenSize 屏幕的size，可以通过该size来判断是横屏还是竖屏
 *  @param  superViewSize 该控件的super view的size，可以通过该size，辅助该控件重新布局
 *  @param  frame 控件默认的位置
 *  @return 控件新设置的位置
 */
typedef CGRect(^ACLBuildFrameBlock)(CGSize screenSize, CGSize superViewSize, CGRect frame);

@interface ACLCustomModel : NSObject

/**
 * 说明，可设置的Y轴距离，waring: 以下所有关于Y轴的设置<=0都将不生效，请注意
 * 全屏模式：默认是以375x667pt为基准，其他屏幕尺寸可以根据(ratio = 屏幕高度/667)比率来适配，比如 Y*ratio
 */

#pragma mark- 弹窗模式设置
/**
 *  授权页面中，渲染并显示所有控件的view，称content view，不实现默认为全屏模式
 *  实现弹窗的方案  width < 屏幕宽度 || height < 屏幕高度
 */
@property (nonatomic, assign) CGSize contentViewSize;

/**customView 展现形式。0默认全屏，1弹窗（屏幕居中），2底部弹窗*/
@property (nonatomic, assign) ACLContentViewType contentViewType;

/** contentViewType == 1 时有效*/
@property (nonatomic, assign) UIModalTransitionStyle modalTransitionStyle;

#pragma mark- 授权页弹出方向
/** 授权页弹出方向，默认ACLPresentationDirectionBottom */
@property (nonatomic, assign) ACLPresentationDirection presentDirection;

#pragma mark- 授权页弹出动画
@property (nonatomic, assign) BOOL isPresentAnimated;

#pragma mark- 竖屏、横屏模式设置
/** 屏幕是否支持旋转方向，默认UIInterfaceOrientationMaskPortrait，注意：在刘海屏，UIInterfaceOrientationMaskPortraitUpsideDown属性慎用！ */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;

#pragma mark- 仅弹窗模式属性

/**自定义窗口弧度 默认是10*/
@property (nonatomic, assign) CGFloat cornerRadius;

#pragma mark- 全屏、弹窗模式共同属性

#pragma mark- 状态栏
/** 状态栏主题风格，默认UIStatusBarStyleDefault */
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;

#pragma mark- 返回按钮
/** 导航栏返回图片 */
@property (nonatomic, strong) UIImage *navBackImage;
/** 是否隐藏授权页返回按钮，默认不隐藏 */
@property (nonatomic, assign) BOOL hideNavBackBtn;
/** 构建返回按钮的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) ACLBuildFrameBlock backBtnFrameBlock;

#pragma mark- logo图片
/** logo图片设置 */
@property (nonatomic, strong) UIImage *logoImage;
/** logo是否隐藏，默认NO */
@property (nonatomic, assign) BOOL logoIsHidden;
/** 构建logo的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) ACLBuildFrameBlock logoFrameBlock;

#pragma mark- slogan
/** slogan文案，内容、字体、大小、颜色 */
@property (nonatomic, copy) NSAttributedString *sloganText;
/** slogan是否隐藏，默认NO */
@property (nonatomic, assign) BOOL sloganIsHidden;

/** 构建slogan的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) ACLBuildFrameBlock sloganFrameBlock;

#pragma mark- 号码
/** 号码颜色设置 */
@property (nonatomic, strong) UIColor *numberColor;
/** 号码字体大小设置，大小小于16则不生效 */
@property (nonatomic, strong) UIFont *numberFont;

/**
 *  号码相对contengView顶部的Y轴距离，不设置则按默认处理
 *  注：设置超出父视图 content view 时不生效
 */
@property (nonatomic, assign) CGFloat numberOffsetY;
/**
 *  号码相对屏幕中线的X轴偏移距离，不设置则按默认处理，默认为0水平居中
 *  注：设置不能超出父视图 content view
 */
@property (nonatomic, assign) CGFloat numberOffsetX;

#pragma mark- 登录
/** 登陆按钮文案，内容、字体、大小、颜色*/
@property (nonatomic, strong) NSAttributedString *loginBtnText;
/** 登录按钮背景图片组，默认高度50.0pt，@[激活状态的图片,失效状态的图片,高亮状态的图片] */
@property (nonatomic, strong) NSArray<UIImage *> *loginBtnBgImgs;
/**
 *  构建登录按钮的frame，view布局或布局发生变化时调用，不实现则按默认处理
 *  注：不能超出父视图 content view，height不能小于40，width不能小于父视图宽度的一半
 */
@property (nonatomic, copy) ACLBuildFrameBlock loginBtnFrameBlock;

#pragma mark- 切换到其他方式
/** changeBtn标题，内容、字体、大小、颜色 */
@property (nonatomic, copy) NSAttributedString *changeBtnTitle;
/** changeBtn是否隐藏，默认NO*/
@property (nonatomic, assign) BOOL changeBtnIsHidden;

/** 构建changeBtn的frame，view布局或布局发生变化时调用，不实现则按默认处理 */
@property (nonatomic, copy) ACLBuildFrameBlock changeBtnFrameBlock;

#pragma mark- 协议
/** checkBox图片组，[uncheckedImg,checkedImg]*/
@property (nonatomic, copy) NSArray<UIImage *> *checkBoxImages;
/** checkBox是否勾选，默认NO */
@property (nonatomic, assign) BOOL checkBoxIsChecked;
/** checkBox大小，高宽一样，必须大于0 */
@property (nonatomic, assign) CGFloat checkBoxWH;
/** 隐私条款默认协议是否开启书名号 */
@property (nonatomic, assign) BOOL privacySymbol;
/** 协议1，[ [协议名称,协议Url]，[协议名称,协议Url], ...] 注：协议名称不能相同 */
@property (nonatomic, copy) NSArray<NSArray *> *privacyLinkArray;
/** 协议内容颜色数组，[非点击文案颜色，点击文案颜色] */
@property (nonatomic, copy) NSArray<UIColor *> *privacyColors;
/** 协议整体文案，前缀部分文案 */
@property (nonatomic, copy) NSString *privacyPreText;
/** 协议整体文案，后缀部分文案 */
@property (nonatomic, copy) NSString *privacySufText;
/** 协议整体文案字体大小，小于12.0不生效 */
@property (nonatomic, strong) UIFont *privacyFont;

/**
 *  构建协议整体（包括checkBox）的frame，view布局或布局发生变化时调用，不实现则按默认处理
 *  如果设置的width小于checkBox的宽则不生效，最小x、y为0，最大width、height为父试图宽高
 *  最终会根据设置进来的width对协议文本进行自适应，得到的size是协议控件的最终大小
 */
@property (nonatomic, copy) ACLBuildFrameBlock privacyFrameBlock;

#pragma mark - Toast文案
/**默认文案：“请勾选登录协议”，如果为空，则点击时无提示。该属性被合法赋值（非空，且最大长度为100的字符串。*/
@property (nonatomic, strong) NSString *checkTipText;

#pragma mark- 协议详情页
/** web协议界面导航栏返回图片 */
@property (nonatomic, strong) UIImage *webNavBackImage;

/**web协议界面导航标题栏颜色*/
@property (nonatomic, strong) UIColor *webNavColor;

/**web协议界面导航标题字体属性设置
 默认值：@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:16]}
*/
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *webNavTitleAttrs;
#pragma mark- 其他自定义控件添加及布局

/**
 * 自定义控件添加，注意：自定义视图的创建初始化和添加到父视图，都需要在主线程！！
 * @param  superCustomView 父视图
*/
@property (nonatomic, copy) void(^customViewBlock)(UIView *superCustomView);

/**
 *  每次授权页布局完成时会调用该block，可以在该block实现里面可设置自定义添加控件的frame
 *  @param  screenSize 屏幕的size
 *  @param  contentViewFrame content view的frame，
 *  @param  logoFrame logo图片的frame
 *  @param  sloganFrame slogan的frame
 *  @param  numberFrame 号码栏的frame
 *  @param  loginFrame 登录按钮的frame
 *  @param  changeBtnFrame 切换到其他方式按钮的frame
 *  @param  privacyFrame 协议整体（包括checkBox）的frame
*/
@property (nonatomic, copy) void(^customViewLayoutBlock)(CGSize screenSize, CGRect contentViewFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame);

@end

NS_ASSUME_NONNULL_END

