### 10.2.1 线程的基本用法

```kotlin
fun main() {
    MyThread().start() // 1
    Thread(MyThread2()).start() // 2

    // 3
    Thread {
        println("Lambda Thread run")
    }.start()

    // 4
    thread {
        println("thread")
    }
}

class MyThread: Thread() {
    override fun run() {
        println("MyThread run")
    }
}

class MyThread2: Runnable {
    override fun run() {
        println("MyThread2 run")
    }

}
```

### 10.2.2 在子线程中更新UI

直接在子线程中操作UI元素会报错：

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    button.setOnClickListener {
        thread {
            updateTextView()
        }
    }
}

private fun updateTextView() {
        textView.text = "Nice to meet you."
    }
```

需要用到`Handle`和`Message`，这样写：

```kotlin
class MainActivity : AppCompatActivity() {

    val updateText = 1
    private val handle = object : Handler() {
        override fun handleMessage(msg: Message) {
            // 在这里可以进行UI操作
            when (msg.what) {
                updateText -> {
                    updateTextView()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        button.setOnClickListener {
            thread {
                val msg = Message()
                msg.what = updateText
                handle.sendMessage(msg)
            }
        }
    }

    private fun updateTextView() {
        textView.text = "Nice to meet you."
    }
}
```

注：`object: Handle(){}`是创建了`Handle`的一个实例



### 10.2.3  解析异步消息处理机制

主要由4部分组成

1. Message
2. Handler
3. MessageQueue
4. Looper



### 10.2.4 使用AsyncTask

一个实现了AsyncTask的下载类：

```kotlin
class DownloadTask: AsyncTask<Unit, Int, Boolean>() {

    private val TAG = "DownloadTask"

    override fun onPreExecute() {
        progressDialog.show() //显示进度对话框
    }

    override fun doInBackground(vararg params: Unit?): Boolean {

        return true
    }

    override fun onProgressUpdate(vararg values: Int?) {
        Log.i(TAG, "onProgressUpdate: $values")
        // 在这里更新下载进度
        progressDialog.setMessage("Downloaded ${values[0]}%")
    }

    override fun onPostExecute(result: Boolean?) {
        Log.i(TAG, "onPostExecute, result: $result")
        // 在这里提示下载结果
        if (result) {
            Toast.makeText(context, "Download successed", Toast.LENGTH_SHORT).show()
        } else {
            Toast.makeText(context, "Download failed", Toast.LENGTH_SHORT).show()
        }
    }
}
```

## 

## 10.3 Service的基本用法

### 10.3.1 定义一个service

New -> Service -> Service，`MyService`

```kotlin
class MyService : Service() {

    override fun onBind(intent: Intent): IBinder {
        TODO("Return the communication channel to the service.")
	      return null
    }

    override fun onCreate() {
        super.onCreate()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onDestroy() {
        super.onDestroy()
    }
}
```

### 10.3.2 启动和停止service

Activity 中的代码:

```kotlin
startServiceBtn.setOnClickListener {
    val serviceIntent = Intent(this, MyService::class.java)
    startService(serviceIntent)
}
stopServiceBtn.setOnClickListener {
    val intent = Intent(this, MyService::class.java)
    stopService(intent)
}
```



### 10.3.3 Activity 和 Service 进行通信

在 Service 类中创建 `DownloadBind` 类，用来和 activity 用于通信

```kotlin
class MyService : Service() {
		...
    private val binder = DownloadBind()

    override fun onBind(intent: Intent): IBinder? {
        Log.i(TAG, "onBind")
        return binder
    }
		...
    class DownloadBind: Binder() {
        fun startDownload() {
            Log.i(TAG, "开始下载")
        }
        fun getProgress(): Int {
            Log.i(TAG, "获取下载进度")
            return  0
        }
    }
}
```

在 Activity 中，写和 Service 的绑定关系

connection 为实例化了一个匿名类

```kotlin
class MainActivity : AppCompatActivity() {

    lateinit var downloadBind: MyService.DownloadBind
    private val connection = object : ServiceConnection {

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.i("MainActivity", "onServiceDisconnected")
        }

        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            downloadBind = service as MyService.DownloadBind
            downloadBind.startDownload()
            val progress = downloadBind.getProgress()
            Log.i("MainActivity", "progress:$progress")
        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        ...
        bindServiceBtn.setOnClickListener {
            val serviceIntent = Intent(this, MyService::class.java)
            bindService(serviceIntent, connection, Context.BIND_AUTO_CREATE)
        }
        unbindServiceBtn.setOnClickListener {
            unbindService(connection)
        }
    }
}
```

## 10.4  Service的生命周期

- `onCreate()`
- `onStartCommand()`
- `onBind()`
- `onDestroy()`



## 10.5 Service的更多技巧



### 10.5.1 使用前台Service

在普通Service的基础上，进行如下改动：

```kotlin
override fun onCreate() {
    super.onCreate()
    Log.i(TAG, "onCreate")
    setToForegroundService()
}
private fun setToForegroundService() {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chanel = NotificationChannel("my_service", "前台Service通知", NotificationManager.IMPORTANCE_DEFAULT)
            manager.createNotificationChannel(chanel)
        }
        val intent = Intent(this, MainActivity::class.java)
        val pi = PendingIntent.getActivity(this, 0, intent, 0)
        val notification = NotificationCompat.Builder(this, "my_service")
            .setContentTitle("This is content title")
            .setContentText("This is content text")
            .setSmallIcon(R.drawable.small_icon)
            .setLargeIcon(BitmapFactory.decodeResource(resources, R.drawable.large_icon))
            .setContentIntent(pi)
            .build()
        startForeground(1, notification)
    }
```

注册一下权限：

```xml
<manifest>
  	...
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
		...
</manifest>
```

效果如下，看起来就是一个通知：

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ge17jc9g3ej30ay0j9wfj.jpg" alt="image-20200421110332690" style="zoom:67%;" />

### 10.5.2 使用IntentService

IntentService 相比普通的 Service，有如下优点：

- 异步（这样耗时的操作就不会影响主线程了）
- 会自动停止

新建`MyIntentService`类：

```kotlin
class MyIntentService: IntentService("MyIntentService") {
    override fun onHandleIntent(intent: Intent?) {
        // 打印当前线程的id
        Log.i("MyIntentService", "Thread name is ${Thread.currentThread().name}")
        // Thread name is IntentService[MyIntentService]
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.i("MyIntentService", "onDestroy executed")
    }
}
```

在 Activity 中启动 MyIntentService：

```kotlin
startMyIntentServiceBtn.setOnClickListener {
    // 打印主线程的id
    Log.i("MainActivity", "MainActivity Thread name is ${Thread.currentThread().name}")
    // MainActivity Thread name is main
    val intentService = Intent(this, MyIntentService::class.java)
    startService(intentService)
}
```

这样就很方便了，可以在`onHandleIntent()`中执行耗时比较多的操作，运行完成后，会自动停止，打印的完整log如下：

```kotlin
/*
I/MainActivity: MainActivity Thread name is main
I/MyIntentService: Thread name is IntentService[MyIntentService]
I/MyIntentService: onDestroy executed
*/
```



## 10.6 Kotlin课堂：泛型的高级特性

### 10.6.1 对泛型进行实例化

泛型实化需要在语法上满足：必须用`inline`和`reified`修饰

例如：

```kotlin
inline fun <reified T> getGenericType() = T::class.java
```

测试：

```kotlin
fun main() {
    val str = "abc"
    val int = 123
    println("str type: ${getGenericType(str)}") // str type: class java.lang.String
    println("int type: ${getGenericType(int)}") // int type: class java.lang.Integer
}
```

### 10.6.2 泛型实化的应用

创建`reified.kt`文件，实现方法：

```kotlin
inline fun <reified T> startActivity(context: Context) {
    val intent = Intent(context, T::class.java)
    context.startActivity(intent)
}
```

这样，启动 activity 就简单了一些：

```kotlin
fun testReified() {
    startActivity<MainActivity>(this)
}
```



考虑到传参数，可以这样修改：

```kotlin
inline fun <reified T> startActivity(context: Context, block: Intent.() -> Unit) {
    val intent = Intent(context, T::class.java)
    intent.block()
    context.startActivity(intent)
}
```

然后这样传参：

```kotlin
fun testReified() {
    startActivity<MainActivity>(this) {
        putExtra("name", "李懿哲")
        putExtra("age", "30")
    }
}
```

> Swift也有类似的用法，但没这么复杂，用`Type`表示类型，`Class.Self`作为参数传过去



### 10.6.3 泛型的协变

个人理解：为了避免类型转换的安全隐患而出现的概念

用`out`修饰后，表示该参数只出不进，参考示例：

```kotlin
fun main() {
    println("str type: ${getGenericType<String>()}")
    println("int type: ${getGenericType<Int>()}")

    val student = Student("Tom", 19)
    val data = SimpleData<Student>(student)
    handleSimpleData(data)
    val studentData = data.get()
}

open class Person(val name: String, val age: Int)
class Student(name: String, age: Int): Person(name, age)
class Teacher(name: String, age: Int): Person(name, age)

class SimpleData<out T>(private val data: T?) {

    fun get(): T? {
        return data
    }
}

fun handleSimpleData(data: SimpleData<Person>) {
    val teacher = Teacher("Jack", 35)
}
```

### 10.6.4 泛型的逆变

个人理解：只进不出，就不会出现安全隐患

用法示例：

```kotlin
interface Transformer<in T> {
    fun transform(t: T): String
}

fun handleSimpleData(data: Transformer<Teacher>) {
    
}

fun main() {
    val trans = object : Transformer<Person> {
        override fun transform(t: Person): String {
            return "${t.name}, ${t.age}"
        }
    }
    handleSimpleData(trans)
}
```

系统中用到的示例：

```kotlin
interface Comparable<in T> {
    operator fun compareTo(other: T): Int
}
```

