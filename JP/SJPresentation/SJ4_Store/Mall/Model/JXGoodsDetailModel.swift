//
//  JXGoodsDetailModel.swift
//  gold
//
//  Created by SJXC on 2021/8/19.
//

import UIKit
import HandyJSON

class JXGoodsDetailModel: HandyJSON {
    required init(){}
    var specs: Array<JXGoodsSpecsModel?> = []
    var isCollect: String = ""
    var detail: JXMallDetailModel? = nil
}

class JXPriceModel: HandyJSON {
    required init(){}
    var itemId: String = ""
    var goodsId: String = ""
    var key: String = ""
    var keyName: String = ""
    var price: String = ""
    var marketPrice: String = ""
    var storeCount: String = ""
    var barCode: String = ""
    var sku: String = ""
    var specImg: String = ""
    var promId: String = ""
    var promType: String = ""
}


class JXGoodsSpecsModel: HandyJSON {
    required init(){}
    var name: String = ""
    var items: Array<JXSpecsItemModel?> = []

}

class JXSpecsItemModel: HandyJSON {
    required init(){}
    var itemId: String = ""
    var item: String = ""
}
