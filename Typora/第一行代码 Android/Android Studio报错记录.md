## ①

```kotlin
Caused by: org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed
```

I solved it changing the gradle version of the project to the newest version 6.2.1 on the project structure options.

[![image](https://user-images.githubusercontent.com/3351420/75755922-86821080-5d27-11ea-82a3-3cc2bc286f05.png)](https://user-images.githubusercontent.com/3351420/75755922-86821080-5d27-11ea-82a3-3cc2bc286f05.png)

引用自:https://github.com/android/plaid/issues/818#issuecomment-593824196

## ② 下拉刷新的组件 SwipeRefreshLayout  找不到

在xml中写布局的时候，没有提示，直接写上去也没报错，但运行的时候报错：

```
java.lang.ClassNotFoundException: androidx.swiperefreshlayout.widget.SwipeRefreshLayout
```

Material 库也在app/build.gradle中引入了，后来在so上找到了一种方式试了一下解决了：

直接引入`implementation 'androidx.swiperefreshlayout:swiperefreshlayout:1.0.0'`库

参考自：https://stackoverflow.com/a/57743939