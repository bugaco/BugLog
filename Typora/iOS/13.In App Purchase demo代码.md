# In App Purchase demo代码

## 0.导入用到的Kit

```swift
import SwiftyStoreKit
import StoreKit
```

## 1.从自己服务器获取iap商品项目

```
var iapItems = [IAPItem]() {
        didSet {
            topCollectionView.reloadData()
        }
}
...
private func fetchIAPItems() {
        IAPRepository.share.list { (result) in
            switch result {
                case .success(let items):
                    self.iapItems = items
                case .failure(let msg):
                    makeToast(msg)
            }
        }
}
...    
```

## 2.用户点击某个iap item后，从apple服务器查询有效性

```swift
    func handleIAP(_ index: Int) {
        let iapItem = iapItems[index]
        MBHudManager.showHud(view)
        SwiftyStoreKit.retrieveProductsInfo([iapItem.productId]) { result in
            MBHudManager.hideHud(self.view)
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self.purchase(product)
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
```

## 3.有效的话，购买

```swift
private func purchase(_ product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            print("canMakePayments")
        } else {
            print("can not MakePayments")
        }
        
        MBHudManager.showHud(self.view)
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
```

## 4.支付的回调

```swift
extension BalanceViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        MBHudManager.hideHud(view)
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
              complete(transaction: transaction)
              break
            case .failed:
              fail(transaction: transaction)
              break
            case .restored:
              restore(transaction: transaction)
              break
            case .deferred:
              break
            case .purchasing:
                print("purchasing")
              break
                @unknown default:
                    print("@unknown default")
                    break
            }
          }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        let productId = transaction.payment.productIdentifier
        print("支付成功：\(productId)")
        makeToast("支付成功")
        SKPaymentQueue.default().finishTransaction(transaction)
        
        // 告知服务器充值成功，然后刷新余额
        handleIAPPurchaseSuccess()
      }
     
      private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
     
        print("restore... \(productIdentifier)")
        SKPaymentQueue.default().finishTransaction(transaction)
      }
     
      private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        makeToast("支付失败")
        if let transactionError = transaction.error as NSError?,
          let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
          }

        SKPaymentQueue.default().finishTransaction(transaction)
      }
}
```

