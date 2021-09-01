//
//  QUBIanH5ActiveAdCenter.h
//  quBianSDK
//
//  Created by 凌锋晨 on 2021/6/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface QUBIanH5ActiveAdData : NSObject
/*
 广告位ID,平台申请  必传
 */
@property (nonatomic, strong) NSString *positionID;

/*
 秘钥,接入时向我方商务人员索取  必传
 */
@property (nonatomic, strong) NSString *appSecret;


/*
 APP标识符，接入时向我方商务人员索取  必传
 */
@property (nonatomic, strong) NSString *appId;


/*
 渠道号，接入方投放渠道：如：APPStore  必传
 */
@property (nonatomic, strong) NSString *channelId;


/*
 接入方用户唯一标识符，必传
 */
@property (nonatomic, strong) NSString *appUserId;


/*
 互动场景的ID 接入时向我方商务人员索取  必传
 */
@property (nonatomic, strong) NSString *gameAppId;
@end





@interface QUBIanH5ActiveAdCenter : NSObject

///***************H5互动游戏广告*******************/
///// @param navigationController push互动游戏界面用
///// @param data 相关参数data
+(void)qb_showH5RewardVideoAd:(UINavigationController *)navigationController ActiveAdData:(QUBIanH5ActiveAdData*)data;

@end

NS_ASSUME_NONNULL_END
