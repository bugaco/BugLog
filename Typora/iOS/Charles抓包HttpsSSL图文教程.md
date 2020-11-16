# Charles抓包Https/SSL图文教程

[![img](https://upload.jianshu.io/users/upload_avatars/12218267/d1ccb711-07de-4ca6-afad-28e457ea5437.png?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96)](https://www.jianshu.com/u/864b14296315)

[pokeey](https://www.jianshu.com/u/864b14296315)关注

0.3542020.04.16 13:20:49字数 302阅读 1,090

#### 电脑端：

打开Charles ->Help->SSL Proxying



![img](https://upload-images.jianshu.io/upload_images/12218267-bbf386b3c089dd31.png?imageMogr2/auto-orient/strip|imageView2/2/w/356)

SSL Proxying



选择Install Charles Root Certificate，安装Charles的证书到电脑中

#### 手机端

以iPhone为例，打开手机，进入设置->Wifi，需要和电脑在同一网段下，点击Info按钮进入wifi的详细信息，

![img](https://upload-images.jianshu.io/upload_images/12218267-6c8567e20056b8be.png?imageMogr2/auto-orient/strip|imageView2/2/w/746)

进入Info


选择配置代理

![img](https://upload-images.jianshu.io/upload_images/12218267-e8364f7605f4577e.png?imageMogr2/auto-orient/strip|imageView2/2/w/732)

配置代理


ip地址填入电脑端的ip地址，端口固定为8888

![img](https://upload-images.jianshu.io/upload_images/12218267-1dd7ffed6fb44f22.png?imageMogr2/auto-orient/strip|imageView2/2/w/696)

配置代理


然后打开手机上的Safari，输入地址chls.pro/ssl，这个时候会弹出一个配置文件下载的弹窗，选择下载

![img](https://upload-images.jianshu.io/upload_images/12218267-82735589c81fbbf0.png?imageMogr2/auto-orient/strip|imageView2/2/w/688)

下载配置文件



![img](https://upload-images.jianshu.io/upload_images/12218267-f635188d6d96259f.png?imageMogr2/auto-orient/strip|imageView2/2/w/598)

下载完成


打开设置，会出现一个已下载描述文件

![img](https://upload-images.jianshu.io/upload_images/12218267-fc93e62711a4e608.png?imageMogr2/auto-orient/strip|imageView2/2/w/736)

已下载描述文件


点击安装

![img](https://upload-images.jianshu.io/upload_images/12218267-68cb1ab925ff88c8.png?imageMogr2/auto-orient/strip|imageView2/2/w/764)

安装描述文件


返回设置->通用->关于本机 拉到最下面,证书信任设置

![img](https://upload-images.jianshu.io/upload_images/12218267-ee6633bffe55f89b.png?imageMogr2/auto-orient/strip|imageView2/2/w/714)

关于本机


打开开关，表示信任该证书

![img](https://upload-images.jianshu.io/upload_images/12218267-fde4140664edb93c.png?imageMogr2/auto-orient/strip|imageView2/2/w/728)

证书信任设置



![img](https://upload-images.jianshu.io/upload_images/12218267-5aa8d79368024e41.png?imageMogr2/auto-orient/strip|imageView2/2/w/720)

image.png


这个时候证书都配置完了
如果是这台手机和电脑第一次连接的话这个时候Charles会弹出一个弹窗，选择**Allow**



![img](https://upload-images.jianshu.io/upload_images/12218267-c5f19336d03d8101.png?imageMogr2/auto-orient/strip|imageView2/2/w/301)

打开SSL



这个时候手机发出的请求就会被Charles劫持，在需要抓包的连接上，右键弹出菜单，选择Enable SSL Proxying，这个时候手机再次发出该请求后便会被解释出来



----

复制自：https://www.jianshu.com/p/98b1fea7ce34