//
//  QUBIanSDKConfig.h
//  quBianSDK
//
//  Created by 凌锋晨 on 2020/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QBConfigBlock)(BOOL success);

@interface QUBIanSDKConfig : NSObject

+(QUBIanSDKConfig *)getDefaultInstance;

-(void)setAppID:(NSString *)appId callback:(QBConfigBlock)block;

@end

NS_ASSUME_NONNULL_END
