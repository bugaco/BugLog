

> 创建自己的Pods库，用来管理自己的工具库，是很久以前就有的想法了，今天终于付诸实践了

跟着[教程](https://code.tutsplus.com/tutorials/creating-your-first-cocoapod--cms-24332)一步步发布了自己的第一个库

### 1 创建库

```ruby
pod lib create LYZBlinkingLabel
```

### 2 验证有效性

```ruby
pod lib lint LYZBlinkingLabel.podspec
```

根据提示，修复错误、警告

### 3 添加github仓库地址，首次提交：

```ruby
git remote add origin git@github.com:zanyzephyr/LYZBlinkingLabel.git
git push -u origin master
```

验证：

```ruby
pod lib lint LYZBlinkingLabel.podspec
```

## Making Your Pod Available

### Step 1: Tagging

```ruby
git tag 0.1.0
git push origin 0.1.0
// Total 0 (delta 0), reused 0 (delta 0)
// To github.com:zanyzephyr/LYZBlinkingLabel.git
//  * [new tag]         0.1.0 -> 0.1.0
```

### Step 2: Validation

```ruby
pod spec lint LYZBlinkingLabel.podspec 
```



### Step 3: Pushing to Specs Repository

```ruby
pod trunk push LYZBlinkingLabel.podspec
```

成功截图：

![image-20200413173123998](https://tva1.sinaimg.cn/large/007S8ZIlly1gds9se5ur1j30fv034jrh.jpg)

