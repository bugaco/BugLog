记录一次WKWebView cookie同步的问题：

引入穿山甲SDK后，会引起自己用到的WKWebView cookie同步异常。

尝试了很多办法之后，都没有解决。最后只有让穿山甲SDK初始化延迟一下，暂时解决了。