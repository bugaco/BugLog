## 5.1 Fragment是什么

Fragment 是一种可以嵌入在 Activity 中的 UI 片段，可以理解为是一种迷你型的 Activity

### 5.2.1 Fragment的简单用法

#### 1⃣️ 创建左边的Fragment布局文件、Kotlin类

`left_fragment.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical" android:layout_width="match_parent"
    android:layout_height="match_parent">

    <Button
        android:id="@+id/button"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:text="Button" />
</LinearLayout
```

`LeftFragment.kt`

```kotlin
class LeftFragment: Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.left_fragment, container, false)
    }
}
```

#### 2⃣️ 创建右边的Fragment布局文件、类文件

`right_fragment.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#00FF00"
    android:orientation="vertical">

    <TextView
        android:id="@+id/textView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:text="This is right fragment."
        android:textSize="24sp" />
</LinearLayout>
```

`RightFragment.kt`

```kotlin
class RightFragment: Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.right_fragment, container, false)
    }
}
```

#### 3⃣️ 修改`activity_main.xml`中的内容：

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal"
    >

    <fragment
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1"
        android:name="com.example.fragmenttest.LeftFragment"
        android:id="@+id/leftFragment" />
    <fragment
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1"
        android:name="com.example.fragmenttest.RightFragment"
        android:id="@+id/rightFragment" />


</LinearLayout>
```

效果图：

![image-20200413205429249](https://tva1.sinaimg.cn/large/007S8ZIlly1gdsfsgotwmj316o0u0ju0.jpg)

### 5.2.2 动态添加Fragment

#### 1⃣️ 再创布局文件`another_right_fragment.xml`和类：`AnotherRightFragment`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#FFFF00"
    android:orientation="vertical">

    <TextView
        android:id="@+id/textView"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:text="This is another right fragment."
        android:textSize="24sp" />
</LinearLayout>
```

```kotlin
class AnotherRightFragment: Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.another_right_fragment, container, false)
    }
}
```

#### 2⃣️ 修改`activity_main.xml`中的布局

将 RightFragment 嵌入 FrameLayout 中

```xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal">

    <fragment
        android:id="@+id/leftFragment"
        android:name="com.example.fragmenttest.LeftFragment"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1" />

    <FrameLayout
        android:id="@+id/rightLayout"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1">

        <fragment
            android:id="@+id/rightFragment"
            android:name="com.example.fragmenttest.RightFragment"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />
    </FrameLayout>


</LinearLayout>
```

#### 3⃣️ 在 MainActivity 中，点击按钮，替换 Fragment

```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        ...
        button.setOnClickListener {
            replace(AnotherRightFragment()) // 1
        }
    }

    private fun replace(fragment: Fragment) {
        val fragmentManager = supportFragmentManager // 2
        val transaction = fragmentManager.beginTransaction() // 3
        transaction.replace(R.id.rightLayout, fragment) // 4
        transaction.commit() // 5
    }
}
```

#### 总结：动态添加 Fragment 主要分为5步

1. 创建待添加的 Fragment
2. 获取 FragmentManager
3. 开启一个事务
4. 向容器内添加或替换Fragment，替换一般使用 `replace() `实现，需要传入容器的ID和待添加的实例
5. 提交事务

### 5.2.3 在Fragment中实现返回栈

在 FragmentTransaction 中，调用 `addToBackStack()`放

```kotlin
private fun replace(fragment: Fragment) {
    val fragmentManager = supportFragmentManager
    val transaction = fragmentManager.beginTransaction()
    transaction.replace(R.id.rightLayout, fragment)
    transaction.addToBackStack(null)
    transaction.commit()
}
```

### 5.2.4 Fragment 和 Activity 之间的交互

#### 1⃣️ Activity 和 Fragment 的交互

#### 在 activity 中，可以通过`findFragmentById()`来获取相关的 fragment，简写为直接通过 fragment 的 ID 来获取对应的 fragment

```kotlin
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
       ...
        val leftFragment = leftFragment as LeftFragment
        leftFragment.foo()
    }

    ...

    fun foo() {

    }
}
```

#### 2⃣️ Fragment 和 Activity 的交互

在 fragment 中，可以通过 activity 属性，获取所在的 activity：

```kotlin
class LeftFragment: Fragment() {
    ...

    fun foo() {
        (activity as MainActivity)?.foo()
    }
}
```

#### 3⃣️ Fragment 和 Fragment 的交互

先找到 activity，再通过 activity 找到 另外的fragment

## 5.3 Fragment 的生命周期

### 5.3.1

和 Activity 差不多，不过 Fragment 还提供了一些附加的回调方法：

- `onAttach()`：当 Fragment 和 Activity 建立关联时调用
- `onCreateView()`：为Fragment创建视图（加载布局）时调用
- `onActivityCreated()`：与 Fragment 相关联的 Activity 已经创建完毕时调用
- `onDestroyView()`：当与 Fragment 关联的视图被移除时调用

- `onDetach()`：当 Fragment 和 Activity 解除关联时调用



### 5.3.2 体验 Fragment 的生命周期

在`RightFragment.kt`中添加如下生命周期相关的代码：

```kotlin
class RightFragment : Fragment() {

    companion object {
        private const val TAG = "RightFragment"
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        Log.d(TAG, "onAttach")
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate")
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        Log.d(TAG, "onCreateView")
        return inflater.inflate(R.layout.right_fragment, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        Log.d(TAG, "onActivityCreated")
    }

    override fun onStart() {
        super.onStart()
        Log.d(TAG, "onStart")
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume")
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause")
    }

    override fun onStop() {
        super.onStop()
        Log.d(TAG, "onStop")
    }

    override fun onDestroyView() {
        super.onDestroyView()
        Log.d(TAG, "onDestroyView")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "onDestroy")
    }

    override fun onDetach() {
        super.onDetach()
        Log.d(TAG, "onDetach")
    }
}
```

1⃣️启动时

![image-20200414141557961](https://tva1.sinaimg.cn/large/007S8ZIlly1gdt9re3gulj30nv0gmjro.jpg)

打印：

```kotlin
/*
2020-04-14 14:13:45.819 11201-11201/com.example.fragmenttest D/RightFragment: onAttach
2020-04-14 14:13:45.819 11201-11201/com.example.fragmenttest D/RightFragment: onCreate
2020-04-14 14:13:45.820 11201-11201/com.example.fragmenttest D/RightFragment: onCreateView
2020-04-14 14:13:45.830 11201-11201/com.example.fragmenttest D/RightFragment: onActivityCreated
2020-04-14 14:13:45.831 11201-11201/com.example.fragmenttest D/RightFragment: onStart
2020-04-14 14:13:45.836 11201-11201/com.example.fragmenttest D/RightFragment: onResume
*/
```

2⃣️点击左边的按钮，RightFragment 被替换掉后

![image-20200414142157111](https://tva1.sinaimg.cn/large/007S8ZIlly1gdt9xlfjisj30o00gut91.jpg)

输出：

```kotlin
/*
2020-04-14 14:21:15.722 11201-11201/com.example.fragmenttest D/RightFragment: onPause
2020-04-14 14:21:15.722 11201-11201/com.example.fragmenttest D/RightFragment: onStop
2020-04-14 14:21:15.722 11201-11201/com.example.fragmenttest D/RightFragment: onDestroyView
*/
```

3⃣️ 点击返回按钮

![image-20200414142615885](https://tva1.sinaimg.cn/large/007S8ZIlly1gdta22ujzoj30nx0gijro.jpg)

输出：

按书中所述，应该输出如下日志：

![image-20200414143025721](https://tva1.sinaimg.cn/large/007S8ZIlly1gdta6eurc2j30dp03q76s.jpg)

但实际没有任何输出，可能和我写的代码有关，那一块的布局文件，书中的好像有问题，自己琢磨着写的

4⃣️ 再次点击返回按钮

app 退出

打印日志：

![image-20200414142823436](https://tva1.sinaimg.cn/large/007S8ZIlly1gdta4a7pd2j30r501kq32.jpg)



## 5.4 动态加载布局的技巧

### 5.4.1 使用限定符

新建一个`layout-large`目录，在目录中新建`activity_main.xml`布局文件：

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal">

    <fragment
        android:id="@+id/leftFragment"
        android:name="com.example.fragmenttest.LeftFragment"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1" />

    <fragment
        android:id="@+id/rightFragment"
        android:name="com.example.fragmenttest.RightFragment"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="3" />

</LinearLayout>
```

注释掉`replaceFragment`方法，在平板和手机上分别运行，就会自动加载两套不同的布局文件

手机：

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gdtbodyrktj30as0kyt9m.jpg" alt="image-20200414152218947" style="zoom: 50%;" />

平板：

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gdtbp3q76rj30ny0hjaae.jpg" alt="image-20200414152259726" style="zoom: 67%;" />

这样就实现了在程序运行时动态加载布局的功能

#### 常用限定符

**屏幕大小限定符**

| 限定符 | 描述                     |
| ------ | ------------------------ |
| small  | 提供给小屏幕设备的资源   |
| normal | 提供给中屏幕设备的资源   |
| large  | 提供给大屏幕设备的资源   |
| xlarge | 提供给超大屏幕设备的资源 |

**屏幕分辨率限定符**

| 限定符 | 描述                                           |
| :----- | :--------------------------------------------- |
| ldpi   | 提供给低分辨率设备的资源（120dpi以下）         |
| mdpi   | 提供给中等分辨率设备的资源（120dpi~160dpi）    |
| hdpi   | 提供给高分辨率设备的资源（160dpi～240dpi）     |
| xhdpi  | 提供给超高分辨率设备的资源（240dpi～320dpi）   |
| xxhdpi | 提供给超超高分辨率设备的资源（320dpi～480dpi） |

**屏幕方向限定符**

| 限定符 | 描述                 |
| :----- | :------------------- |
| land   | 提供给横屏设备的资源 |
| port   | 提供给竖屏设备的资源 |

### 5.4.2 使用最小宽度限定符

开门见山，直接看例子了

1⃣️ 新建`layout-sw600dp`文件夹，新建`activity_main.xml`布局文件

`sw`为`small-width`的简写

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gdtjiz1yp8j30gs0dgq40.jpg" alt="image-20200414195348775" style="zoom:50%;" />

文件中的内容：

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal">

    <fragment
        android:id="@+id/leftFragment"
        android:name="com.example.fragmenttest.LeftFragment"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1" />

    <FrameLayout
        android:id="@+id/rightLayout"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1">

        <fragment
            android:id="@+id/rightFragment"
            android:name="com.example.fragmenttest.RightFragment"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />
    </FrameLayout>


</LinearLayout>
```

> 当程序运行在屏幕宽度大于等于600dp的设备上时，就会加载`layout-sw600dp/activity_main.xml`布局，当程序运行在宽度小于600dp的设备上时，就会加载`layout/activity_main.xml`布局。

## 5.5 Fragment最佳实践：一个简易版的新闻应用

#### （0）先上一下最终效果图吧：

手机：

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gdtpwvo3m3j30l610o0vq.jpg" alt="image-20200414233447893" style="zoom:50%;" />

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1gdtpxceyl4j30l2110aeq.jpg" alt="image-20200414233516788" style="zoom:50%;" />

平板：

![image-20200414233541727](https://tva1.sinaimg.cn/large/007S8ZIlly1gdtpxs1fcyj317i0u0441.jpg)

#### （1）在 app/build.gradle 中添加 recyclerview 依赖:

```ruby
dependencies {
    ...
    implementation 'androidx.recyclerview:recyclerview:1.1.0'
    ...
}
```

#### （2）新建 News 类

```kotlin
class News(val title: String, val content: String)
```

#### （3）新建`news_content_frag.xml`布局文件、`NewsContentFragment`类

布局文件中，主要有标题、内容，以及左边、中间两个分割线

```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent" android:layout_height="match_parent">
    <LinearLayout
        android:id="@+id/newsContentLayout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:visibility="invisible"
        android:orientation="vertical"
        >

        <TextView
            android:id="@+id/newsTitle"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:textSize="20sp"
            android:padding="10dp"
            android:layout_gravity="center"
            />
        <View
            android:layout_width="match_parent"
            android:layout_height="1dp"
            android:background="#000"
            />
        <TextView
            android:id="@+id/newsContent"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="1"
            android:textSize="18sp"
            android:padding="15dp"
            android:layout_gravity="center"
            />
    </LinearLayout>
    <View
        android:layout_width="1dp"
        android:layout_height="match_parent"
        android:background="#000"
        android:layout_alignParentLeft="true"
        />
</RelativeLayout>
```

`NewsContentFragment`类：

类中主要实现了加载布局文件、刷新新闻title、content的功能

#### （4）新建`NewsContentActivity`类，用于手机设备中显示新闻内容

**布局文件：**

复用了`news_content_frag`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".NewsContentActivity">

    <fragment
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:name="com.example.fragmentbestpractice.NewsContentFragment"
        android:id="@+id/newsContentFrag"
        />

</androidx.constraintlayout.widget.ConstraintLayout>
```

**类文件：**

```kotlin
class NewsContentActivity : AppCompatActivity() {

    companion object {
        fun actionStart(context: Context, title: String, content: String) {
            val intent = Intent(context, NewsContentActivity::class.java).apply {
                putExtra("news_title", title)
                putExtra("news_content", content)
            }
            context.startActivity(intent)
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_news_content)

        val title = intent.getStringExtra("news_title")
        val content = intent.getStringExtra("news_content")
        if (title != null && content != null) {
            val fragment = newsContentFrag as NewsContentFragment
            fragment.refresh(title, content) // 刷新NewsContentFragment的界面
        }
    }
}
```

类中主要实现了：

1. 在`onCreate`方法中，获取`intent`中的参数，刷新 fragment 的 UI 显示
2. 创建供其他类调用的类方法

#### （5）创建`news_title_frag.xml`、`news_item.xml`布局文件和`NewsTitleFragment`类

`news_title_frag.xml`：

就一个`RecyclerView`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/newsTitleRecyclerView"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        />
</LinearLayout>
```

`news_item.xml`:

⚠️起初这里自己写的时候，根元素设置为了`LinearLayout`，结果cell全部重叠在一起了❌

```xml
<?xml version="1.0" encoding="utf-8"?>
<TextView xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/newsTitle"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:ellipsize="end"
    android:maxLines="1"
    android:paddingLeft="10dp"
    android:paddingTop="15dp"
    android:paddingRight="10dp"
    android:paddingBottom="15dp"
    android:textSize="18sp" />
```

NewsTitleFragment`:

```kotlin
class NewsTitleFragment : Fragment() {

    private var isTwoPane = false

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.news_title_frag, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        isTwoPane = activity?.findViewById<View>(R.id.newsContentLayout) != null
        val layoutManager = LinearLayoutManager(activity)
        newsTitleRecyclerView.layoutManager = layoutManager
        val newsList = getNews()
        val adapter = NewsAdapter(newsList)
        newsTitleRecyclerView.adapter = adapter
    }

    private fun getNews(): List<News> {
        val newsList = ArrayList<News>()
        for (i in 1..50) {
            val news = News(
                "This is news title - $i",
                getRandomLengthContentString("This is news content $i\n")
            )
            newsList.add(news)
        }
        return newsList
    }


    private fun getRandomLengthContentString(str: String): String {
        val n = (2..20).random()
        val builder = StringBuilder().apply {
            repeat(n) {
                append(str)
            }
        }
        return builder.toString()
    }

    inner class NewsAdapter(val newsList: List<News>) :
        RecyclerView.Adapter<NewsAdapter.ViewHolder>() {
        inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
            val newsTitle: TextView = itemView.findViewById(R.id.newsTitle)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context)
                .inflate(R.layout.news_item, parent, false)
            val holder = ViewHolder(view)

            holder.itemView.setOnClickListener {
                val news = newsList[holder.adapterPosition]
                if (isTwoPane) {
                    val fragment = newsContentFrag as NewsContentFragment
                    fragment.refresh(news.title, news.content)
                } else {
                    NewsContentActivity.actionStart(parent.context, news.title, news.content)
                }
            }

            return holder
        }

        override fun getItemCount(): Int = newsList.size

        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            holder.newsTitle.text = newsList[position].title
        }

    }
}
```

类中的内容多一些

- 在`onCreateView`中加载对应的布局文件

- 在`onActivityCreated`中，设置 RecyclerView 的 layoutManager 和 adapter

- 创建内部类 NewsAdapter

  类中，运行时根据设备是1页还是2页，对cell点击事件作出了不同的响应

  

#### （6）利用限定符，创建手机、平板的布局文件

`layout`目录下的`activity_main.xml`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/newsTitleLayout"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <fragment
        android:id="@+id/newsTitleFrag"
        android:name="com.example.fragmentbestpractice.NewsTitleFragment"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />

</FrameLayout>
```

`layout-sw600dp`目录下的`activity_main.xml`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/newsTitleLayout"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="horizontal">

    <fragment
        android:id="@+id/newsTitleFrag"
        android:name="com.example.fragmentbestpractice.NewsTitleFragment"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="1" />

    <FrameLayout
        android:id="@+id/newsContentLayout"
        android:layout_width="0dp"
        android:layout_height="match_parent"
        android:layout_weight="3">

        <fragment
            android:id="@+id/newsContentFrag"
            android:name="com.example.fragmentbestpractice.NewsContentFragment"
            android:layout_width="match_parent"
            android:layout_height="match_parent" />
    </FrameLayout>

</LinearLayout>
```

运行，完事。

文档的记录顺序，并非完全的代码编写顺序，只是这样写的时候，缩减了一些步骤



## 5.6 Kotlin课堂：扩展函数和运算符重载

### 5.6.1 大有用途的扩展函数

和Swift的思想是类似的，不继承、改变原有类代码的情况下，像该类添加方法，写法有所不同。

给`String`类添加一个方法：

```kotlin
fun String.lettersCount(): Int {
    var count = 0
    for (char in this) {
        if (char.isLetter()) {
            count ++
        }
    }
    return count
}
```

然后就可以直接调用了：

```kotlin
val count = "abc123;df32".lettersCount()
```

### 5.6.2 有趣的运算符重载

这个语法糖确实很有趣

定义 Money 类，和它的 plus、minus方法：

```kotlin
class Money(var value: Int) {

    operator fun plus(money: Money) {
        value += money.value
        money.value = 0
    }
    operator fun minus(value: Int) {
        this.value -= value
    }

    override fun toString(): String {
        return "${value}元".toString()
    }
}
```

然后试一下效果：

```kotlin
fun main() {
    val myMoney = Money(100)
    val yourMoney = Money(50)
    myMoney + yourMoney
    myMoney - 10 // 上了2小时网
    println("My money: ${myMoney.toString()}\nYour money: ${yourMoney.toString()}")
  	/** 输出：
  	My money: 140元
		Your money: 0元
		*/
}
```

**语法糖表达式和实际调用函数对照片**

| 语法糖表达式 | 实际调用函数   |
| ------------ | -------------- |
| a + b        | a.plus(b)      |
| a - b        | a.minus(b)     |
| a * b        | a.times(b)     |
| a / b        | a.div(b)       |
| a % b        | a.rem(b)       |
| a++          | a.inc()        |
| a--          | a.dec()        |
| +a           | a.unaryPlus()  |
| -a           | a.unaryMinus() |
| !a           | a.not()        |
| a == b       | a.equals(b)    |
| a..b         | a.rangeTo(b)   |
| a[b]         | a.get(b)       |
| a[b]=c       | a.set(b,c)     |
| a in b       | b.contains(a)  |

配合1⃣️重载运算符和之前学过的2⃣️类的扩展方法，以及内置的 `repeat(str: String)`函数，我们可以将之前写的，重复字符串多次的方法重构为如下：

`StringExtension.kt`文件：

```kotlin
operator fun String.times(times: Int): String = repeat(times)
```

获取随机长度的字符串：

```kotlin
private fun getRandomLengthContentString(str: String): String {
    return str * (1..20).random()
}
```

