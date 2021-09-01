//
//  QBAdDelegate.h
//  quBianSDK
//
//  Created by 凌锋晨 on 2020/11/24.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#pragma mark 开屏广告回调
@protocol QBSplashAdDelegate <NSObject>

@optional

///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
- (void) qb_onSplashAdFail:(NSString*)error;

///广告渲染成功
- (void) qb_onSplashAdExposure;

/// 广告被点击
- (void) qb_onSplashAdClicked;

/// 广告被跳过
- (void) qb_onSplashAdClose;

@end






#pragma mark 插屏广告回调
@protocol QBInterActionAdDelegate <NSObject>

@optional

///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
- (void) qb_onInterActionAdFail:(NSString*)error;

///广告渲染成功
- (void) qb_onInterActionAdExposure;

///广告被关闭
- (void) qb_onInterActionAdDismiss;

///广告被点击
- (void) qb_onInterActionAdClicked;

/////视频准备就绪开始播放（非视频广告不回调）
- (void) qb_onInterActionVideoReady;

/////视频播放完成（非视频广告不回调）
- (void) qb_onInterActionVideoComplete;

@end





#pragma mark banner广告回调
@protocol QBBannerAdDelegate <NSObject>

@optional

///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
- (void) qb_onBannerAdFail:(NSString*)error;

///广告渲染成功
- (void) qb_onBannerAdExposure;

///广告被关闭
- (void) qb_onBannerAdDismiss;

///广告被点击
- (void) qb_onBannerAdClicked;

///banner 高度(部分返回)
-(void) qb_BannerHeight:(CGFloat)height;

@end





#pragma mark 信息流广告广告回调
@protocol QBNativeAdDelegate <NSObject>

@optional

///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
- (void) qb_onNativeAdFail:(NSString*)error;

///广告加载成功，刷新数据
- (void) qb_onNativeAdloadSuccessWithDataArray:(NSMutableArray *)adDataArray;

///点击不喜欢，关闭广告
- (void) qb_onNativeAdClickDislike:(id)data;

///广告渲染成功
- (void) qb_onNativeAdExposure;

///广告被关闭
- (void) qb_onNativeAdDismiss;

///广告被点击
- (void) qb_onNativeAdClicked;

///视频准备就绪开始播放（非视频广告不回调）
- (void) qb_onNativeVideoReady;

///视频播放完成（非视频广告不回调）
- (void) qb_onNativeVideoComplete;

@end





#pragma mark  激励视频广告回调
@protocol QBRewardVideoAdDelegate <NSObject>

@optional
///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
- (void) qb_onRewardAdFail:(NSString*)error;

///视频被点击
- (void) qb_onRewardAdClicked;

///视频被关闭
- (void) qb_onRewardAdClose;

///视频广告曝光
- (void) qb_onRewardAdExposure;

///视频广告加载完成，此时播放视频不卡顿
- (void) qb_onRewardVideoCached;

///激励视频触发激励（观看视频大于一定时长或者视频播放完毕）
- (void) qb_onRewardVerify;

@end


#pragma mark  draw竖版视频信息流广告回调
@protocol QBDrawNativeVideoAdDelegate <NSObject>

@optional

///广告加载失败，msg加载失败说明（如果重新请求广告，注意：只重新请求一次）
- (void) qb_onDrawNativeAdFail:(NSString*)error;

///视频被点击
- (void) qb_onDrawNativeAdClicked;

/// 广告曝光回调
- (void) qb_onDrawNativeRenderSuccess;

///广告加载成功，刷新数据
- (void) qb_onDrawNativeAdloadSuccessWithDataArray:(NSMutableArray *)adDataArray;
@end


#pragma mark  UnifiedNativeAd
@protocol QBUnifiedNativeAdDelegate <NSObject>
@optional
//返回广告数据回调 unifiedNativeAdDataObjects数组中的元素类型为GDTUnifiedNativeAdDataObject
- (void)qb_unifiedNativeAdLoaded:(NSArray*)unifiedNativeAdDataObjects :(NSError *)error;
//广告点击回调
- (void)qb_unifiedNativeAdClick;
//广告展示回调
- (void)qb_unifiedNativeAdExposure;
@end

NS_ASSUME_NONNULL_END
