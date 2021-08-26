//
//  BookStoreMgr.h
//  YuemengSdkDemo
//
//  Created by wangdh on 2019/5/7.
//  Copyright © 2019 wangdh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;


@interface BookStoreMgr : NSObject

//+(id)getDefaultStoreMgr;

-(void) openBookStore;
-(void) openBookStoreByUrl:(NSString *)url;
-(BOOL) handleOpenURL:(NSURL *)url;
-(void) openTaskController;

-(UIViewController *) getBookStoreWebviewController;

@end

NS_ASSUME_NONNULL_END
