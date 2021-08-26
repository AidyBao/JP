//
//  AdSdkCenter.h
//  com.ibookstar.sdk
//
//  Created by wangdh on 2017/9/21.
//  Copyright © 2017年 wangdh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol YMBookStoreDelegate <NSObject>

@optional
//SDK打开通知
-(void) yuemengSdkDidOpen;

//SDK关闭通知
-(void) yuemengSdkDidClose;

//通知SVIP状态
-(void) notifySVIPUser;

@end

@interface YuemengAdSdkCenter : NSObject

-(NSString *) getSDKVersion;

/*
 bookStoreId:分配的书城Id，必填
 delegate:关心用户是否vip时，可以填这个参数，否则填nil
 */
-(id)initYuemengSdkWithBookStoreId:(NSInteger) bookStoreId delegate:(id<YMBookStoreDelegate>) delegate;

-(void) setBookStoreDelegate:(id<YMBookStoreDelegate>) delegate;

//设置落地页webview navigation bar 图标和文字颜色
-(void) setWebiewNavigationbarTitleColor:(UIColor *)color;

//设置落地页webview navigation bar 背景颜色
-(void) setWebiewNavigationbarBgColor:(UIColor *)color;

//navigation bar，title区域上方显示自定义的view
-(void) setCustomHeaderView:(UIView *)customView;

/*
 返回书城id对应的书城首页
 参数thirdUserId:三方用户id，可以填nil
 */
-(UIViewController *) getBookStoreWebviewController:(NSString *)thirdUserId;

/*
 present方式打开书城首页
 参数thirdUserId:三方用户id，可以填nil
 */
-(void) presentBookStore:(NSString *)thirdUserId;

/*
 present方式打开书城书架
 参数thirdUserId:三方用户id，可以填nil
 */
-(void) presentBookStoreShelf:(NSString *)thirdUserId;

//动态运营位打开SDK
-(BOOL) presentBookStoreByUrl:(NSString *)url :(NSString *)thirdUserId;

/*
 响应特定的schema参数(redirectUrl)，直接打开对应的
 参数url：需要交给SDK处理的scheme
 参数thirdUserId:三方用户id，可以填nil
 */
-(BOOL) handleOpenURL:(NSURL *)url :(NSString *)thirdUserId;

/*
 *任务中心接口
 */
-(void) presentTaskController:(NSString *)thirdUserId;

@end
