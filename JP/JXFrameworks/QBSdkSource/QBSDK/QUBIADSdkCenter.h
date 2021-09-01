//
//  QUBIADSdkCenter.h
//  quBianSDK
//
//  Created by 凌锋晨 on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QBAdDelegate.h"

#define qbSdkVersion @"gc_2.2.2"

typedef NS_ENUM(NSInteger, QBAdShowDirection) {
    QBAdShowDirection_Vertical         =           0,  //竖屏
    QBAdShowDirection_Horizontal,                       //横屏
};

NS_ASSUME_NONNULL_BEGIN

@interface QUBIADSdkCenter : NSObject

@property (nonatomic, weak) id <QBSplashAdDelegate> splashDelegate;
@property (nonatomic, weak) id <QBInterActionAdDelegate> interActionAdDelegate;
@property (nonatomic, weak) id <QBBannerAdDelegate> bannerAdDelegate;
@property (nonatomic, weak) id <QBNativeAdDelegate> nativeAdDelegate;
@property (nonatomic, weak) id <QBRewardVideoAdDelegate> rewardVideoAdDelegate;
@property (nonatomic, weak) id <QBDrawNativeVideoAdDelegate> drawNativeVideoAdDelegate;
@property (nonatomic, weak) id <QBUnifiedNativeAdDelegate> unifiedNativeAdDelegate;

/***************普通开屏广告调用方法*******************/
/// 开屏广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面
/// @param bottomView 开屏底下logo页面，可不传(全屏页面)
-(void) qb_showSplashAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController bottomView:(UIView * __nullable)bottomView;
/// 不需要bottomView时可调用此方法
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面
-(void) qb_showSplashAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController;
/// 关闭开屏广告
-(void) qb_closeSplashAd;


/***************视频(V+)开屏广告调用方法*******************/
/// 开屏广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面
/// @param bottomView 开屏底下logo页面，可不传(全屏页面)
-(void) qb_showVideoSplashAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController bottomView:(UIView * __nullable)bottomView;
/// 不需要bottomView时可调用此方法
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面
-(void) qb_showVideoSplashAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController;
-(void) qb_closeVideoSplashAd;


/***************插屏广告调用方法*******************/
/// 插屏广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController  调用界面.
-(void) qb_showInterActionAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController;

/***************banner广告调用方法*******************/
/// banner广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面.
-(void) qb_showBannerAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController bannerframe:(CGRect)bannerFrame;
/// banner广告调用
/// 广告加载到superview上
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面.
-(void) qb_showBannerAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController bannerframe:(CGRect)bannerFrame bannerSuperView:(UIView*)superview;

/***************信息流广告广告调用方法*******************/
/// 信息流广告广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面
-(void) qb_showNativeAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController adFrame:(CGRect)adframe;
//获取广告cell高度
- (CGFloat)qb_heightForNativeAd:(id)adData;
//获取cell
- (UITableViewCell *)qb_tableView:(UITableView *)tableView cellForForNativeAd:(id)adData IndexPath:(NSIndexPath *)indexPath;


/***************激励视频广告调用方法*******************/
/// 激励视频广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面.
/// @param userId 接入方用户唯一识别表示(可传nil，当userid为nil或者为空时，产生奖励之后无服务器回调).
-(void) qb_showRewardVideoAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController showDirection:(QBAdShowDirection)direction userID:(NSString*)userId;

/// 激励视频广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面.
/// @param userId 接入方用户唯一识别表示(可传nil，当userid为nil或者为空时，产生奖励之后无服务器回调).
/// @param extraData 接入方自定义内容
/// @retuen 唯一订单号
-(NSString *) qb_showRewardVideoAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController showDirection:(QBAdShowDirection)direction userID:(NSString*)userId extraData:(NSString *)extraData;

/// 显示激励视频广告
-(void) showRewardVideoAd;

/***************draw竖版视频信息流广告调用方法*******************/
/// draw竖版视频信息流广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面.
-(void) qb_showDrawNativeVideoAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController;
/// draw竖版视频信息流广告调用
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 调用界面.
/// @param adContainerView 广告容器view.
-(void) qb_showDrawNativeVideoAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion rootViewController:(UIViewController *)rootViewController adContainerView:(UIView *)adContainerView;
/// draw竖版视频信息流广告 获取广告UITableViewCell
/// @param tableView 显示的tableview
/// @param adData 广告数据
/// @param indexPath table的indexPath
/// @return UITableViewCell
- (UITableViewCell *)qb_tableView:(UITableView *)tableView cellForForDrawVideoAd:(id)adData IndexPath:(NSIndexPath *)indexPath;
/// draw竖版视频信息流广告 获取广告UICollectionViewCell
/// @param collectionView 显示的UICollectionView
/// @param adData 广告数据
/// @param indexPath table的indexPath
/// @return UICollectionViewCell
- (UICollectionViewCell *)qb_collectionView:(UICollectionView *)collectionView cellForForDrawVideoAd:(id)adData IndexPath:(NSIndexPath *)indexPath;



/***************信息流自渲染广告调用方法*******************/
/// 请求信息流自渲染广告数据
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param delegate 接收协议类
/// @param count 加载广告数量
-(void)qb_requestUnifiedAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion delegate:(id)delegate loadAdCount:(NSInteger)count;
///信息流自渲染广告视图注册
///@param dataObject 数据对象，必传字段
///@param clickableViews 可点击的视图数组，此数组内的广告元素才可以响应广告对应的点击事件
///@param customClickableViews 可点击的视图数组，与clickableViews的区别是：在视频广告中当dataObject中的videoConfig的detailPageEnable为YES时，点击后直接进落地页而非视频详情页，除此条件外点击行为与clickableViews保持一致
- (void)qb_registerDataObject:(id)dataObject view:(UIView *)view clickableViews:(NSArray<UIView *> *)clickableViews customClickableViews:(NSArray <UIView *> *)customClickableViews;


/***************视频内容+广告样式*******************/
///信息流自渲染广告视图注册
/// @param postionId 广告位ID
/// @param channelNum 渠道号(可传nil)
/// @param channelVersion 渠道版本号(可传nil，但是有渠道号的时候不能为nil)
/// @param rootViewController 显示内容列表样式的viewController ,内容会添加到viewController.view 上
/// @param rect 内容样式的frame
-(void)qb_showContentStyleAd:(NSString *)postionId channelNum:(NSString *)channelNum channelVersion:(NSString *)channelVersion viewController:(UIViewController *)rootViewController contentStyleViewFrame:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
