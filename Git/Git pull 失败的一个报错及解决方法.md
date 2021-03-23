# Git pull 失败的一个报错及解决方法

项目初始化的时候，本地新建了一个项目，远程git上也初始化了一个空的仓库，但是包含`.gitignore`文件，本地pull操作的时候，会报错：

```
fatal: refusing to merge unrelated histories
```

这时，可以在后面加一个参数，允许合并不相关的历史记录：

```
git pull origin master --allow-unrelated-histories
```

