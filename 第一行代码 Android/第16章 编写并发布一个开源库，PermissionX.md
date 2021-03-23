> 简单记录一下发布开源库的过程吧

在`library`的`build.gradle`中，新增如下配置：

```kotlin
apply plugin: 'com.novoda.bintray-release'
buildscript {
    repositories {
        jcenter()
    }
    dependencies {
        classpath 'com.novoda:bintray-release:0.9.2'
    }
}
publish {
    userOrg = 'zanyzephyr'
    groupId = 'com.zanyzephyr.permissionx'
    artifactId = 'permissionx'
    publishVersion = '1.0.0'
    desc = 'Make Android runtime permission request easy.'
    website = 'https://github.com/zanyzephyr/PermissionX'
}
```

然后在`AS`的`Terminal`中，执行如下命令：

```
 ./gradlew clean build bintrayUpload -PbintrayUser=zanyzephyr -PbintrayKey=[MyKey] -PdryRun=false
```

看到如下日志，则表明这一步成功了，然后在`bintray`网站中提交`Add to JCenter`

---

**后续**

在"PermissionXTest"项目中，确实成功引入了自己的库，但是没有 PermissionX 类，查看了一下 Library 目录，里边并没有源文件❌

这一章节的实践并没有完全成功。