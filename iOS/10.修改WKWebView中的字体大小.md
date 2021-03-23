## 修改字体大小

Google了很多方法，只有这一种，在缩放之后，WKWebView显示的内容正常

```javascript
document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '180%';
```





## javascript修改指定class的 css



### 1⃣️

如果用jquery的话，比较简单

```javascript
$('.article .info').css('height', '2.0rem');
```

### 2⃣️

很不幸，项目有加载本地html文件的情况，但再导入一下jquery文件的话，有点杀鸡用牛刀了。

Google了一下，可以用javascript原生的：

```javascript
document.querySelectorAll('.article .info')[0].style.height='2.0rem';
```

