//
//  XJAppPayManager.swift
//  LeiFengHao
//
//  Created by xj on 2022/8/31.
//

import UIKit
import StoreKit

class AppPayManager: NSObject {
    
    var proId: String!
    
    // 沙盒验证地址
    let url_receipt_sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    // 生产环境验证地址
    let url_receipt_itunes = "https://buy.itunes.apple.com/verifyReceipt"

    // 21008表示生产换使用  21007表示测试环境使用
    var state = 21008
    
    let verify_type = 0

    var resultBlock: (_ result: String)->Void = { (_ result: String)->Void in }
    
    static var shared: AppPayManager = AppPayManager()
    
    private override init() {
        
    }
    override class func copy() -> Any {
        return self
    }
    
}

extension AppPayManager: SKPaymentTransactionObserver {
    //MARK: 发起购买请求 实现发起购买请求，参数一商品id，参数2回调逃逸闭包(商品id，也就是在开发者网站添加商品的id，在这里可以先提供一个com.saixin.eduline6)
    func startPay(proId: String, resultBlock: @escaping ((_ result: String) -> Void)) {
        self.resultBlock = resultBlock
        if !SKPaymentQueue.canMakePayments() {
            print("不可使用苹果支付")
            return
        }
        //监听购买结果
        SKPaymentQueue.default().add(self)
        self.proId = proId
        let set = Set.init([proId])
        let requst = SKProductsRequest.init(productIdentifiers: set)
        requst.delegate = self
        requst.start()
    }
}

extension AppPayManager: SKProductsRequestDelegate {
    //MARK: 发起购买请求回调代理方法
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let productArray = response.products
        if productArray.count == 0 {
            print("此商品id没有对应的商品")
            return
        }
        var product: SKProduct!
        for pro in productArray {
            if pro.productIdentifier == proId {
                product = pro
                break
            }
        }
        print(product.description)
        print(product.localizedTitle)
        print(product.localizedDescription)
        print(product.price)
        print(product.productIdentifier)
        let payment = SKMutablePayment.init(product: product)
        payment.quantity = 1
        SKPaymentQueue.default().add(payment)
    }

    //MARK: 购买结果 监听回调
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for tran in transactions {
            switch tran.transactionState {
            case .purchased: //购买完成
                SKPaymentQueue.default().finishTransaction(tran)
                completePay(transaction: tran)
                break
            case.purchasing: //商品添加进列表
                break
            case.restored: //已经购买过该商品
                SKPaymentQueue.default().finishTransaction(tran)
                break
            case.failed: //购买失败
                SKPaymentQueue.default().finishTransaction(tran)
                break
            default:
                break
            }
        }
    }

    //MARK: 购买成功验证凭证
    func completePay(transaction: SKPaymentTransaction) {
        //获取交易凭证
        let recepitUrl = Bundle.main.appStoreReceiptURL
        let data = try! Data.init(contentsOf: recepitUrl!)
        if recepitUrl == nil {
            self.resultBlock("交易凭证为空")
            print("交易凭证为空")
            return
        }
        
        if verify_type == 0 {//客户端验证
            verify(data: data, transaction: transaction)
        }else{//服务器端校验
            
        }
        //注销交易
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    //MARK: 客户端验证
    func verify(data: Data, transaction: SKPaymentTransaction)  {
        let base64Str = data.base64EncodedString(options: .endLineWithLineFeed)
        let params = NSMutableDictionary()
        params["receipt-data"] = base64Str
        let body = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = URLRequest.init(url: URL.init(string: state == 21008 ? url_receipt_itunes: url_receipt_sandbox)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.httpBody = body
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            let dict = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            print(dict)
            SKPaymentQueue.default().finishTransaction(transaction)
            let status = dict["status"] as! Int
            switch(status){
            case 0:
                self.resultBlock("购买成功")
                break
            case 21007:
                self.state = 21007
                self.verify(data: data!, transaction: transaction)
                break
            default:
                self.resultBlock("验证失败")
                break
            }
            //移除监听
            SKPaymentQueue.default().remove(self)
        }
        task.resume()
    }
}


