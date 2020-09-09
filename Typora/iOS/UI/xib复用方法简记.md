# xib复用方法简记



1. 创建 CustomView 类，以及同名的 xib 文件，CustomView.xib

2. xib文件中，将`File's Owner`关联的`class`设置为`CustomView`

3. 参考以下代码

   ```swift
   @IBDesignable
   class CustomView: UIView {
       lazy var contentView = genContentView()
       override init(frame: CGRect) {
           super.init(frame: frame)
           xibSetup()
       }
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           xibSetup()
       }
       func xibSetup() {
           addSubview(contentView)
       }
   }
   ```

   `genContentView()`是抽取出来的方法：

   ```swift
   // MARK: xib的复用用到的
   extension UIView {
       /// 加载和自身关联的xib文件
       func loadViewFromNib() -> UIView! {
           let seflType = type(of: self)
           let bundle = Bundle(for: seflType)
           let nib = UINib(nibName: String(describing: seflType), bundle: bundle)
           let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
           return view
       }
       
       func genContentView() -> UIView {
           let contentView = loadViewFromNib()
           // use bounds not frame or it'll be offset
           contentView!.frame = bounds
           // Make the view stretch with containing view
           contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           return contentView!
       }
   }
   ```

   

---

参考：https://stackoverflow.com/questions/30335089/reuse-a-uiview-xib-in-storyboard