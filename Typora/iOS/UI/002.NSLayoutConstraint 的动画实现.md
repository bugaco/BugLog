NSLayoutConstraint 的动画实现

```
self.heightFromTop.constant = 550
myView.setNeedsUpdateConstraints()

UIView.animateWithDuration(0.25, animations: {
   myView.layoutIfNeeded()
})
```

> 这个不查资料是真的难弄出来，试的我都怀疑人生了😂