# UIHStackView，Label底部对齐的实现方式

## 需求：

> 一个水平方向的StackView，有两个 Label，让它们底对齐，如下图

![image-20200509170746773](https://tva1.sinaimg.cn/large/007S8ZIlly1gemb7u6z5pj304301mt8i.jpg)

---

## ~~不科学的方法~~

理所当然，肯定会去`Attributes Inspector`中，设置`Aligment`属性为`Bottom`

![image-20200509171231688](https://tva1.sinaimg.cn/large/007S8ZIlly1gembcqee8mj307k022t8l.jpg)

但是效果是这样的：

![image-20200509171317893](https://tva1.sinaimg.cn/large/007S8ZIlly1gembdjf69rj302d01t742.jpg)

之前一直是用不科学的方法:

> 将第一个 Label 的高度，固定为字体的大小

这样勉强实现了效果。



## 正确的方法

今天UI有所调整，按照上面的方法，要重新更改 Label 的高度约束，感觉很麻烦，就查了资料，

发现 UIStackView 的`alignment`属性，默认是`fill`，更改为`lastBaseline`就能实现想要的效果了



具体步骤：

**1、代码**

```swift
class BaseLineHStackView: UIStackView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.alignment = .lastBaseline
    }
}
```

**2、xib**

将 UIStackView 的`class`指定为上文自定义的类：

![image-20200509172424364](https://tva1.sinaimg.cn/large/007S8ZIlly1gembp38e9rj307m02z0sp.jpg)

效果对比（左：更改了`alignment`属性的；右：没有更改的）：

![image-20200509172732230](https://tva1.sinaimg.cn/large/007S8ZIlly1gembscr2z1j305g01yq2v.jpg)

---

## 后续

xib中其实直接有这个属性的，😓

之前的行为显的很是愚蠢，如图：

![image-20200511104744338](https://tva1.sinaimg.cn/large/007S8ZIlly1geobh174joj307903kq3u.jpg)