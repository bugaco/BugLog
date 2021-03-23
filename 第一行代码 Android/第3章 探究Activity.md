### 3.2.3 在AndroidManifest文件中注册

创建一个activity，注册过`MAIN`和`LAUNCHE`后，app才能启动

`AndroidManifest.xml` 中，如下：

```xml
<activity android:name=".FirstActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent-filter>
</activity>
```

`android:label="This is FirstActivity"`标签，不仅指定标题栏中的文本，还会修改Launcher中应用程序的名称：

```xml
android:label="This is FirstActivity"
```

### 3.31 显示调用Intent

```kotlin
val intent = Intent(this, SecondActivity::class.java)
startActivity(intent)
```

### 3.32 使用隐式Intent

创建Intent时，不调用具体的Intent名字，而是写上Intent的`Name`以及`Category`（默认为Default），具体没有详细记录

### 3.33 更多隐式Intent调用

```kotlin
/*打开网址*/
val intent = Intent(Intent.ACTION_VIEW)
intent.data = Uri.parse("https://www.v2ex.com")

/* 拨打电话 */
val intent = Intent(Intent.ACTION_DIAL)
intent.data = Uri.parse("tel: 10010")

startActivity(intent)
```

### 3.34 向下一个Activity传递数据

传递：

```kotlin
val intent = Intent(this, SecondActivity::class.java)
intent.putExtra("extra_data", "Hello SecondActivity")
startActivity(intent)
```

接收：

```kotlin
val extraData: String? = intent.getStringExtra("extra_data")
Log.d("SecondActivity", extraData)
```

### 3.35 返回数据给上一个Activity

#### （1）FirstActivity中跳转

```kotlin
val intent = Intent(this, SecondActivity::class.java)
startActivityForResult(intent, 2020)
```

#### （2）SecondActivity中返回

```kotlin
override fun onBackPressed() {
    val intent = Intent()
    intent.putExtra("data_return", "Hello, FirstActivity!")
    setResult(Activity.RESULT_OK, intent)
    finish()
}
```

#### （3）FirstActivity中接收

```kotlin
override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    when(requestCode) {
        2020 -> {
            when (resultCode) {
                Activity.RESULT_OK -> {
                    val returnData: String? = data?.getStringExtra("data_return")
                    Log.d("FirstActivity", returnData)
                }
            }
        }
    }
}
```

### 3.4.2 Activity状态

这个很好理解

1. **运行状态**

   在前台时候

2. **暂停状态**

   被别的弹窗遮挡，但没有完全遮挡

3. **停止状态**

   不再处于栈顶，完全变为不可见状态时

4. **销毁状态**

   从返回栈中移除，就变成了销毁状态



### 3.4.3 Activity的生存期

* `onCreate()`

  类比`iOS`的`viewDidLoad()`

* `onStart()`

  在Activity由不可变变为可见的时候调用，有点像iOS的`viewWillAppear()`

* `onResume()`

  > 这个方法在Activity准备好和用户进行交互的时候调用

* `onPause()`

  举例：当被别的窗口遮挡，但没有完全遮挡时会调用

* `onStop()`

  完全不可见时调用

* `onDestroy()`

  被销毁之前调用

* `onRestart()`

  由停止状态变为运行状态之前调用

  

  #### 总结

  onCreate 对应 onDestroy

  onStart 对应 onStop

  onResume 对应 onPause

  onRestart 没有对应的，因为onStop时，可能是从栈中移除了，也可能仅仅是未位于栈顶

  

  从另一个维度，又可以将生存期分为三种：

  * 完整生存期

    `onCreate()`和`onDestroy()`之间的

  * 可见生存期

    `onStart()`和`onStop()`

  * 前台生存期

    `onResume()`和`onPause()`

  

  ### 3.4.4 体验 Activity的生命周期

  将Activity声明为Dialog布局

  ```xml
  <activity android:name=".DialogActivity"
      android:theme="@style/Theme.AppCompat.Dialog"></activity>
  ```

  ### 

  ### 3.4.5 Activity被回收了怎么办

  在`onSaveInstanceState()`中保存

  ```kotlin
  override fun onSaveInstanceState(outState: Bundle) {
      super.onSaveInstanceState(outState)
  
      val tempData = "Something you typed."
      outState.putString("extra_data", tempData)
      Log.d(tag, "$tempData 已保存")
  }
  ```

  在`onCreate()`中取出来

  ```kotlin
  override fun onCreate(savedInstanceState: Bundle?) {
      super.onCreate(savedInstanceState)
      setContentView(R.layout.activity_main)
      
      if (savedInstanceState != null) {
          val tempData = savedInstanceState.getString("extra_data")
          Log.d(tag, "获取到了之前存储的数据：$tempData")
      }
  }
  ```

## 3.5 Activity的启动模式

### 3.5.1 standard

无论`Activity`是否存在，都创建一个新的实例

### 3.5.2 singleTop

如果栈顶已经有该Activity实例，则不再创建新的

### 3.5.3 singleTask

整个栈中，只要有该实例，就不再创建新的实例，而且该Activity出栈时，会让它之上的所有Activity出栈

### 3.5.4 singleInstance

会创建一个单独的返回栈

个人理解：就像它的名字，“单实例”，就相当于在整个操作系统中，只会有这一个 Activity 实例

### 3.6.1 知晓当前是在哪一个Activity

思路：创建一个基类，使其他Activity继承该基类，在创建时打印该基类的名字

```kotlin
class BaseActivity: AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("BaseActivity", javaClass.simpleName)
    }
}
```

`javaClass`为当前类的实例

### 3.6.2 随时随地退出程序

创建一个单例来管理app内的所有Activity：

```kotlin
object ActivityController {
    private val activities = ArrayList<Activity>()

    fun addActivity(activity: Activity) {
        activities.add(activity)
    }
    fun removeActivity(activity: Activity) {
        activities.remove(activity)
    }
    fun finishAll() {
        for (activity in activities) {
            if (!activity.isFinishing) {
                activity.finish()
            }
        }
        activities.clear()
    }
}
```

在BaseActivity中，创建时候存入数组，销毁的时候移除数组:

```kotlin
class BaseActivity: AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("BaseActivity", javaClass.simpleName)
        ActivityController.addActivity(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        ActivityController.removeActivity(this)
    }
}
```

点击“退出”按钮，关闭所有activity，退出app：

```kotlin
button3.setOnClickListener {
    ActivityController.finishAll()
}
```



### 3.6.3 启动Activity的最佳写法

创建一个类方法：

```kotlin
class SecondActivity : BaseActivity() {
    ...
    companion object {
        fun actionStart(context: Context, name: String, age: Int) {
            val intent = Intent(context, SecondActivity::class.java)
            intent.putExtra("name", name)
            intent.putExtra("age", age)
            context.startActivity(intent)
        }
    }
}
```

调用的时候：

```kotlin
class FirstActivity : BaseActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.first_layout)
        button1.setOnClickListener {
            SecondActivity.actionStart(this,"ZanyZephyr", 30)
        }
    }
...
}
```



## 3.7 Kotlin课堂：标准函数和静态方法

### 3.7.1 标准函数with、run和apply

#### `with`

with函数接收两个参数：

1. 任意类型的对象
2. Lambda表达式

Demo：

常规吃水果：

```kotlin
fun main() {
    val fruits = listOf<String>("Apple", "Banana", "Orange", "Grape")
    val string = StringBuilder()
    string.append("开始吃水果：\n")
    for (fruit in fruits) {
        string.append(fruit + "\n")
    }
    string.append("吃完了\n")
    println("$string")
}
/* 输出：
开始吃水果：
Apple
Banana
Orange
Grape
吃完了
*/
```

使用with的写法：

```kotlin
fun main() {
    val fruits = listOf<String>("Apple", "Banana", "Orange", "Grape")
    val result = with(StringBuilder()) {
        append("开始吃水果：\n")
        for (fruit in fruits) {
            append("$fruit\n")
        }
        append("吃完了")
        toString()
    }
    println(result)
}
```

#### `run`

和`with`类似：

```kotlin
fun main() {
    val fruits = listOf<String>("Apple", "Banana", "Orange", "Grape")
    val result = StringBuilder().run {
        append("开始吃水果：\n")
        for (fruit in fruits) {
            append("$fruit\n")
        }
        append("吃完了")
        toString()
    }
    println(result)
}
```

#### `reply`

和`run`类似，不同之处在于，`run`无法指定返回值，而是会自动返回调用对象本身：

```kotlin
fun main() {
    val fruits = listOf<String>("Apple", "Banana", "Orange", "Grape")
    val result = StringBuilder().apply {
        append("开始吃水果：\n")
        for (fruit in fruits) {
            append("$fruit\n")
        }
        append("吃完了")
    }
    println(result.toString())
}
```

3.6.3中，启动Activity的写法，就可以稍微简写为下面的了：

```kotlin
...
val intent = Intent(context, SecondActivity::class.java).apply {
    putExtra("name", name)
    putExtra("age", age)
}
...
```

### 3.7.2 定义静态方法

#### （1）用单例形式

某些情况下，可以用单例来实现

```kotlin
fun main() {
    Util.doAction()
}

object Util {
    fun doAction() {

    }
}
```

调用方法看起来相似，但并不是静态方法

#### （2）用`companion object`

```kotlin
fun main() {
    Util.doAction()
}

class Util {

    fun doAction() {

    }

    companion object {
        fun doAction() {

        }
    }
}
```

但这也不是真正的静态方法，在Java代码中无法以静态形式调用

#### （3）注解和顶层方法

##### <1>注解

在 `companion object`或单例方法前加上`@JvmStatic`

```kotlin
class Util {

    companion object {
        @JvmStatic
        fun doAction() {

        }
    }
}

object Util2 {
    @JvmStatic
    fun foo() {

    }
}
```

##### <2>顶层方法

> 顶层方法指的是那些没有定义在任何类中的方法
>
> Kotlin编译器会将所有的顶层方法全部编译成静态方法

定义一个顶层方法：

新建`Helper.kt`文件，创建一个顶层方法：

```kotlin
fun doSomething() {
}
```

这就是一个静态方法，可以在Kotlin中调用：

```kotlin
fun main() {
    doSomething()
}
```

也可以在Java中调用：

```java
public class Test {
    void test() {
        HelperKt.doSomething();
    }
}
```

