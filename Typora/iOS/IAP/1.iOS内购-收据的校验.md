# iOS内购



## 支付成功后，去服务器验证，返回的数据：

## json字符串：

```json
{
"receipt":{"receipt_type":"ProductionSandbox", "adam_id":0, "app_item_id":0, "bundle_id":"com.xihe.refuel", "application_version":"1", "download_id":0, "version_external_identifier":0, "receipt_creation_date":"2021-02-03 01:37:54 Etc/GMT", "receipt_creation_date_ms":"1612316274000", "receipt_creation_date_pst":"2021-02-02 17:37:54 America/Los_Angeles", "request_date":"2021-02-03 01:38:03 Etc/GMT", "request_date_ms":"1612316283021", "request_date_pst":"2021-02-02 17:38:03 America/Los_Angeles", "original_purchase_date":"2013-08-01 07:00:00 Etc/GMT", "original_purchase_date_ms":"1375340400000", "original_purchase_date_pst":"2013-08-01 00:00:00 America/Los_Angeles", "original_application_version":"1.0", 
"in_app":[
{"quantity":"1", "product_id":"test_iap_01", "transaction_id":"1000000773036354", "original_transaction_id":"1000000773036354", "purchase_date":"2021-02-03 01:37:54 Etc/GMT", "purchase_date_ms":"1612316274000", "purchase_date_pst":"2021-02-02 17:37:54 America/Los_Angeles", "original_purchase_date":"2021-02-03 01:37:54 Etc/GMT", "original_purchase_date_ms":"1612316274000", "original_purchase_date_pst":"2021-02-02 17:37:54 America/Los_Angeles", "is_trial_period":"false"}]}, "environment":"Sandbox", "status":0}
```

#### 预览：

![image-20210203094844326](https://tva1.sinaimg.cn/large/008eGmZEly1gna3u88n0bj30jz0lm77e.jpg)

### 字典类型的打印信息：

```objc
{
    environment = Sandbox;
    receipt =     {
        "adam_id" = 0;
        "app_item_id" = 0;
        "application_version" = 1;
        "bundle_id" = "com.xihe.refuel";
        "download_id" = 0;
        "in_app" =         (
                        {
                "is_trial_period" = false;
                "original_purchase_date" = "2021-02-03 01:04:22 Etc/GMT";
                "original_purchase_date_ms" = 1612314262000;
                "original_purchase_date_pst" = "2021-02-02 17:04:22 America/Los_Angeles";
                "original_transaction_id" = 1000000773030851;
                "product_id" = "test_iap_01";
                "purchase_date" = "2021-02-03 01:04:22 Etc/GMT";
                "purchase_date_ms" = 1612314262000;
                "purchase_date_pst" = "2021-02-02 17:04:22 America/Los_Angeles";
                quantity = 1;
                "transaction_id" = 1000000773030851;
            }
        );
        "original_application_version" = "1.0";
        "original_purchase_date" = "2013-08-01 07:00:00 Etc/GMT";
        "original_purchase_date_ms" = 1375340400000;
        "original_purchase_date_pst" = "2013-08-01 00:00:00 America/Los_Angeles";
        "receipt_creation_date" = "2021-02-03 01:04:22 Etc/GMT";
        "receipt_creation_date_ms" = 1612314262000;
        "receipt_creation_date_pst" = "2021-02-02 17:04:22 America/Los_Angeles";
        "receipt_type" = ProductionSandbox;
        "request_date" = "2021-02-03 01:04:26 Etc/GMT";
        "request_date_ms" = 1612314266783;
        "request_date_pst" = "2021-02-02 17:04:26 America/Los_Angeles";
        "version_external_identifier" = 0;
    };
    status = 0;
}
```



## 拿沙盒数据，去正式环境验证，返回的数据：

```json
{
    status = 21007;
}
```



