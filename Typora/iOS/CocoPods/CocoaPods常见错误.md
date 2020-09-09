# CocoaPods常见错误

## 1、RPC failed

**例如：**

```
...
[!] Error installing Bytedance-UnionAD
[!] /usr/bin/git clone https://github.com/bytedance/Bytedance-UnionAD.git /var/folders/ny/vp7y1wrs1nxfnhzs4hk8j2_m0000gn/T/d20200521-53401-1fh4dve --template= --single-branch --depth 1 --branch 2.9.5.6

Cloning into '/var/folders/ny/vp7y1wrs1nxfnhzs4hk8j2_m0000gn/T/d20200521-53401-1fh4dve'...
error: RPC failed; curl 18 transfer closed with outstanding read data remaining
fatal: the remote end hung up unexpectedly
fatal: early EOF
fatal: index-pack failed
...
```

**解决方法：**

查了一圈资料，就是网络不好引起的，换成GCP之后，瞬间完事儿。

参考自：

1.[github issues](https://github.com/ndmitchell/neil/issues/28#issuecomment-474284770)

## 2、CDN: trunk URL couldn't be downloaded

**例如：**

```
Analyzing dependencies
[!] CDN: trunk Repo update failed - 21 error(s):
CDN: trunk URL couldn't be downloaded: https://raw.githubusercontent.com/CocoaPods/Specs/master/Specs/9/2/6/Bytedance-UnionAD/1.9.8.2/Bytedance-UnionAD.podspec.json Response: Couldn't connect to server
CDN: trunk URL couldn't be downloaded: https://raw.githubusercontent.com/CocoaPods/Specs/master/Specs/9/2/6/Bytedance-UnionAD/1.9.8.5/Bytedance-UnionAD.podspec.json Response: Couldn't connect to server
CDN: trunk URL couldn't be downloaded: https://raw.githubusercontent.com/CocoaPods/Specs/master/Specs/9/2/6/Bytedance-UnionAD/1.9.9.2/Bytedance-UnionAD.podspec.json Response: Couldn't connect to server
...
```

**解决方法：**

在`Podfile`文件中，指定 source：

```
source 'https://github.com/CocoaPods/Specs.git'
```

