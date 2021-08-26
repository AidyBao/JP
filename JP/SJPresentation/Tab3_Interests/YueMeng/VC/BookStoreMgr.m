//
//  BookStoreMgr.m
//  YuemengSdkDemo
//
//  Created by wangdh on 2019/5/7.
//  Copyright © 2019 wangdh. All rights reserved.
//

#import "BookStoreMgr.h"
#import "YuemengAdSdkCenter.h"
#import <WebKit/WKWebsiteDataStore.h>

extern long g_imei_user_id;

@interface BookStoreMgr () <YMBookStoreDelegate>

@property (nonatomic, strong) YuemengAdSdkCenter *adCenter;

@property (nonatomic, strong) NSString *thirdUserId;

@end



@implementation BookStoreMgr

+(id)getDefaultStoreMgr{

    static BookStoreMgr *_bookStoreSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bookStoreSingleton = [[BookStoreMgr alloc] init];
    });
    return _bookStoreSingleton;
}

-(id) init
{
    self = [super init];
    if (self){
        
        _thirdUserId = @"abc123dfdsk";
        
        //这里是demo展示的书城Id，合作方使用的书城Id请与商务联系获取
        _adCenter = [[YuemengAdSdkCenter alloc] initYuemengSdkWithBookStoreId:9134 delegate:self];

        //设置navigation title 颜色
        [_adCenter setWebiewNavigationbarTitleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.5]];

        //设置navigation bar 背景颜色
        [_adCenter setWebiewNavigationbarBgColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]];
    }
    
    return self;
}

-(void) dealloc
{
    _adCenter = nil;
}

-(void) openBookStore
{
    [_adCenter presentBookStore:_thirdUserId];
}

-(void) openBookStoreByUrl:(NSString *)url
{
    [_adCenter presentBookStoreByUrl:url :_thirdUserId];
}

-(BOOL) handleOpenURL:(NSURL *)url
{
    return [_adCenter handleOpenURL:url :_thirdUserId];
}

-(UIViewController *) getBookStoreWebviewController
{
    return [_adCenter getBookStoreWebviewController:_thirdUserId];
}

-(void) openTaskController
{
    [_adCenter presentTaskController:_thirdUserId];
}

#pragma --mark YMBookStoreDelegate
//SDK打开通知
-(void) yuemengSdkDidOpen
{
    
}

//SDK关闭通知
-(void) yuemengSdkDidClose
{
    
}

-(void) notifySVIPUser
{
    //初始化后或者用户使用过程中购买了svip，通过这个接口通知app
    
}

@end
