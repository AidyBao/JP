//
//  ZXURLConst.swift
//  YDY_GJ_3_5
//
//  Created by screson on 2017/4/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation
import UIKit

let ZXBOUNDS_WIDTH      =   UIScreen.main.bounds.size.width
let ZXBOUNDS_HEIGHT     =   UIScreen.main.bounds.size.height

class ZX {
    
    static let AppSotreTestTel: String  = "19948429608"
//    static let AppSotreTestTel: String  = "15198238888"
    
    static let PageSize:Int             =   10
    static let HUDDelay                 =   1.2
    static let CallDelay                =   0.5
    static let ZX_Alpha: CGFloat        =   0.35
    
    //定位失败 默认位置
    struct Location {
        static let latitude             =   30.592061
        static let longitude            =   104.063396
    }
}
/// 接口地址
class ZXURLConst {
    struct Api {
        //正式
//        static let url                  =   "https://api.88sjxc.com"
//        static let port                 =   ""
        //测试
        static let url                  =   "https://www.88sjxc.com"
        static let port                 =   ""
    }
    
    struct Resource {
        //正式
//        static let url                  =   "https://api.88sjxc.com"
//        static let port                 =   ""
        //测试
        static let url                  =   "https://www.88sjxc.com"
        static let port                 =   ""
    }
    
    struct WebCND {
        //正式
//        static let cdn    = "https://h5."
        //测试
        static let cdn    = "https://www."
    }
    
    struct Web {
        //服务条款H5
        static let userAgreement   = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/agreement.html"
        static let powerExp    = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/power.html"
        //城市运营中心规则
        static let cityRule = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/rule.html"
        //夺宝规则
        static let gameRule = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/gameRule.html"
        //正式：商城
        static let shop = ZXURLConst.WebCND.cdn + "88sjxc.com/mShop/index.html#/"

    }
    
    struct WX {
        static let oauthAccessToken    =    "https://api.weixin.qq.com/sns/oauth2/access_token?" //获取授权access_token
        static let refreshAccessToken  =    "https://api.weixin.qq.com/sns/oauth2/refresh_token?" //刷新access_token
        static let verfifyAuth         =    "https://api.weixin.qq.com/sns/auth?"                 //检验授权凭证（access_token）是否有效
        static let getWXUserinfo       =    "https://api.weixin.qq.com/sns/userinfo?"              //获取用户个人信息
    }
}

/// 功能模块接口
class ZXAPIConst {
    struct QUBianAD {
        
        ///
        //聚星公社应用ID
        static let APPID    = "1384804713697919041"
//        //聚星公社开屏
        static let KPID     = "1385769406285496389​"
//        //聚星公社激励视频
        static let JLID     = "1385769523377881119​"
//        //聚星公社Draw信息流（短视频）
        static let DrawXXLID = "1385769880174739460​"//首页视频
//        //聚星公社自定义信息流
        static let UnifiedXXLID  = "1385770042964066333"//首页弹窗
    }
    
    //闪电玩
    struct ShandW {
        static let id       = "15299"
        static let appkey   = "3fc4945382b54cb2b78972595f0eb167"
        static let url      = "http://www.shandw.com/auth/?"
    }
    
    //小说
    struct Novel {
        static let id   = 9134
    }
    
    struct System {
        static let time      = "member/getServerTime"
    }
    
    struct FileResouce {
        static let url       = "app/common/upload"           //文件上传接口
        
    }
    
    struct Html {
        //推广分享
        static let registerH5 =  "https://h5.88sjxc.com/loginVgs/register.html?"
        //视频分享
        static let shareVideo =  "https://h5.88sjxc.com/dist/index.html#/share?"
    }
    
    struct common {
        static let version  = "app/common/version"
    }
    
    //MARK: - User
    struct Login {
        //秒杀配置
        static let killCig  = "/app/config/sec-kill-inlet"
        //获取验证码
        static let getSMSCode       =  "app/user-no-login/send-sms"
        //获取验证码
        static let myGetSMSCode     =  "app/my/send-sms-token"
        //手机号登录
        static let telLogin         =  "app/user-no-login/oauth"
        //修改密码
        static let updatePassword   = "app/my/update-login-password"
        //解除绑定
        static let unbinding        = "app/user-no-login/unbind"
        //用户注册
        static let register         = "app/user-no-login/register"
        //验证注册短信
        static let valimsmcode      = "app/user-no-login/vali-msm-code"
    }
    
    struct Auth {
        //微信授权
        static let wechatAuth         =  "app/third/auth/wechat/code"
        //支付宝-提交授权码(app)
        static let alipayAuthCode     =  "app/third/auth/authCode"
        //支付宝-获取授权字符串
        static let alipayAuthInfo     =  "app/third/auth/authInfo"
        //获取certifyId
        static let getFaceCertifyId     =  "app/real-person-auth/setp1"
        //获取认证结果
        static let getFaceAuth          =  "app/real-person-auth/setp2"
    }
    
    //叫号系统
    struct Enroll {
        //签到列表
        static let callList = "app/enroll/callList"
        //关闭报名
        static let closeCall = "app/enroll/closeCall"
        //结束本次海选
        static let closeEnroll = "app/enroll/closeEnroll"
        //签到角色信息
        static let info = "app/enroll/info"
        //报名
        static let memberCall = "app/enroll/memberCall"
        //下一位
        static let next = "app/enroll/next"
        //开启报名
        static let openCall = "app/enroll/openCall"
        //开启签到
        static let openEnroll = "app/enroll/openEnroll"
    }
    
    struct User {
        
        //查询用户基本信息
        static let userInfo         =  "app/my/get-myinfo"
        //
        static let updateMember     = "app/my/update-member"
        //团队数据
        static let teamStatis       =  "app/my/get-team-statistics"
        //会员等级信息
        static let getMemberLevel   = "app/my/get-member-level-info"
        //修改交易密码(身份证方式)
        static let updateTradePass  = "app/my/update-trade-password-idcard"
        //设置支付宝账号(身份证方式)
        static let setAlipayCard    = "app/my/update-member-alipay-idcard"
        //系统公告
        static let sysNoticeList    = "app/notice/query-sys-notice-list"
        
        //反馈列表
        static let problems         = "app/my/problems"
        //反馈详情
        static let problemsDetail   = "app/my/getProblems"
        //新增反馈
        static let addProblems      = "app/my/add"
        //商学院
        static let school           = "app/common/courses"
        //个人-我的上级数据+我的直推团队数
        static let myteamlist       = "app/my/get-myteam-superior-direct"
        static let myteamlisttwo    = "app/my/get-mytwoteam-search"
        static let myteamSearch     = "app/my/get-myteam-search"
        //基础活跃度
        static let baseactive       = "app/my/get-my-baseactive-list"
        //基础活跃度下级
        static let lowerBaseaAtive  = "app/my/get-my-lower-baseactive-list"
        //个人-Gsv兑换积分信息
        static let gsvExchangePoints = "app/my/get-gsv-exchange-points-list"
        //个人-积分兑换Gsv信息
        static let tgExchangeGSV    = "app/my/get-points-exchange-gsv-list"
        //会员经验值列表
        static let expList          = "app/exp/list"
    }
    
    struct Video {
        //删除视频
        static let delVideo = "app/myVideo/delVideo"
        //我的视频列表
        static let myVideo = "app/myVideo/myVideo"
        //
        static let getOssToken = "app/myVideo/getToken"
        //上传视频文件
        static let saveMyVideo = "app/myVideo/save"
        //获取视频
        static let videoList        = "app/video/index"
        //视频点赞
        static let videoUp          =   "app/videoPrivate/videoUp"
        //视频取消点赞
        static let videoCancelUp    =   "app/videoPrivate/videoCancelUp"
        //回复点赞
        static let replyUps         =   "app/videoPrivate/replyUps"
        //取消回复点赞
        static let replyUpsCancel   =   "app/videoPrivate/replyUpsCancel"
        //回复评论
        static let replyComment     = "app/videoPrivate/replyComment"
        //回复别人的回复
        static let replyToReplyer   = "app/videoPrivate/replyToReplyer"
        //关注
        static let follow           = "app/videoPrivate/follow"
        //取消关注
        static let followCancel     = "app/videoPrivate/followCancel"
        //评论列表
        static let commentList      = "app/video/commentList"
        //评论
        static let comment          = "app/videoPrivate/comment"
        //评论点赞
        static let commentUps       = "app/videoPrivate/commentUps"
        //取消评论点赞
        static let commentUpsCancel = "app/videoPrivate/commentUpsCancel"
        //加载更多回复
        static let getMoreReply     = "app/video/getMoreReply"
    }
    
    struct Activity {
        //做任务领经验信息
        static let taskExperienceInfo  = "app/activity/taskExperienceInfo"
        //活动信息
        static let activityInfo   = "app/activity/info"
        //活动banner
        static let activityBanner = "app/activity/banner"
        //获取助力TOKEN
        static let getHelpToken   = "app/activity/getHelpToken"
        //获取助力TOKEN
        static let activityFinish = "app/activity/finish"
        //获取任务收益
        static let getProfit      = "app/activity/getProfit"
    }
    
    struct Pay {
        //获取订单号
        static let getOrderNo   = "app/pay/alipay/getOrderNumber"
        //开始支付
        static let pay          = "shop/shop/pay-do-pay"
    }
    
    struct Exchange {
        //兑换中心-积分兑换Gsv
        static let pointsToGsv = "app/exchange/points-to-gsv"
        //兑换中心-Gsv兑换积分
        static let gsvToPoints = "app/exchange/gsv-to-points"
        //额度明细
        static let quotaList   = "app/my/get-my-quota-records"
    }
    
    struct Card {
        //查询任务包列表
        static let cardList    = "app/task-package/query-task-package-list"
        //查询被购买和还可购买任务包列表
        static let cardGoing   = "app/task-package/query-my-purchased-task-package-group"
        //查询已购买任务包列表
        static let cardfinish  = "app/task-package/query-my-task-package-list"
        //获取通知消息
        static let getMemberNotice  = "app/task-package/getMemberNotice"
        //用币跟平台兑换任务包
        static let gsvExchangTask  = "app/task-package/buy-task-package-by-gsv"
        //用积分跟平台兑换任务包
        static let tgExchangTask  = "app/task-package/buy-task-package-by-points"
        //兑换中心-购卡通知列表
        static let buyCardNotic   = "app/exchange/buy-card-list"
    }
    
    struct Shop {
        //获取地址
        static let getAddress       = ""
        //我的地址列表
        static let addressList      = "shop/shop/user-my-address"
        //设置默认收货地址
        static let setDefault       = "shop/shop/user-address-set-Default"
        //删除地址
        static let delet            = "shop/shop/user-address-del"
        //添加或修改地址
        static let edit             = "shop/shop/user-address-add-edit"
        //获取订单列表
        static let orderList        = "shop/shop/user-order-list"
        //获取订单详情
        static let orderDetail      = "shop/shop/user-order-detail"
        //获取订单操作
        static let orderHandle      = "shop/shop/user-order-handle"
        //订单绑定收货地址
        static let bindAddress      = "shop/shop/order-bind-address"
        //取消订单
        static let cancelOrder      = "shop/shop/cancelOrder"
        //商城
        static let goods    = "shop/shop/integral/goods"
        //商品详情
        static let goodsDetail = "shop/shop/mall-goods-detail"
    }
    
    struct QY {
        //上月战力值
        static let lastMonthCapa = "app/capa/query_befor_order_list"
        //总战力值
        static let capaTotal  = "app/capa/total"
        //前三名
        static let capaThree  = "app/capa/three"
        //查询战力明细列表
        static let capaList = "app/capa/list"
        //查询战力值排行榜列表
        static let capaOrder = "app/capa/order"
        //会员权益模块
        static let profit       = "shop/member/profit"
        //首页banner
        static let profitBanner   = "shop/shop/index-banner"
    }
    
    struct city {
        static let citySearch = "app/city/search"
        static let cityTotal = "app/city/total"
        static let cityList = "app/city/list"
    }
    
    struct Member {
        //配置-会员等级信息
        static let memberLevelList = "app/config/get-member-level-config-list"
    }
    
    //夺宝
    struct Bet {
        static let  openInfos = "app/bet/openInfos"
        static let  waitInfos = "app/bet/waitInfos"
        static let  goodsCode = "app/bet/goodsCode"
        static let  myCode = "app/bet/myCode"
        static let  place = "app/bet/place"
    }
    
    struct Game {
        //大转盘
        static let turntable = ZXURLConst.WebCND.cdn + "88sjxc.com/dist/index.html#/turntable?"
        //时间掌控者
        static let time = ZXURLConst.WebCND.cdn + "88sjxc.com/dist/index.html#/time?"
        //大转盘
        static let shareTime = ZXURLConst.WebCND.cdn + "88sjxc.com/dist/index.html#/shareTime?"
        //大转盘
        static let shareZp = ZXURLConst.WebCND.cdn + "88sjxc.com/dist/index.html#/shareZp?"
        //OTC
        static let otc  = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/index.html#/assets?"
        //签到
        static let signin = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/index.html#/qd?"
        //秒杀
        static let secKill = ZXURLConst.WebCND.cdn + "88sjxc.com/otc/index.html#/shop?"
    }
}
