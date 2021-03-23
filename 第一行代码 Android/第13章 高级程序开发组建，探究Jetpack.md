### 13.2.1 ViewModel的基本用法

1.引入依赖：

```
implementation 'androidx.lifecycle:lifecycle-extensions:2.1.0'
```

2.创建 MainActivity 对应的 ViewModel 类：

```kotlin
class MainViewModel: ViewModel() {
    var counter = 0
}
```

3.布局文件，很简单：

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    tools:context=".MainActivity">

    <TextView
        android:id="@+id/infoText"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:textSize="32sp" />

    <Button
        android:id="@+id/plusOneBtn"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_gravity="center_horizontal"
        android:text="Plus One" />

</LinearLayout>
```

4.在 MainActivity 中使用：

```kotlin
class MainActivity : AppCompatActivity() {

    lateinit var viewModle: MainViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        viewModle = ViewModelProviders.of(this).get(MainViewModel::class.java)
        plusOneBtn.setOnClickListener {
            viewModle.counter ++
            updateTextInfo()
        }
        updateTextInfo()
    }

    private fun updateTextInfo() {
        infoText.text = viewModle.counter.toString()
    }
}
```

这样用 ViewModel 存储后，即使屏幕旋转，Activity 重新创建，数据也不会丢失了

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ge78uu1di3j30ah0if0t0.jpg" alt="image-20200426162236260" style="zoom:50%;" />

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ge78vcu9dvj30ig0alt8z.jpg" alt="image-20200426162258128" style="zoom:50%;" />

### 13.2.2 向ViewModel传递参数

1. 修改`MainViewModel`类：

   ```kotlin
   class MainViewModel(countReserved: Int = 0): ViewModel() {
       var counter = countReserved
   }
   ```

2. 新建`MainViewModelFactory`类：

   ```kotlin
   class MainViewModelFactory(val countReserved: Int): ViewModelProvider.Factory {
       override fun <T : ViewModel?> create(modelClass: Class<T>): T {
           return MainViewModel(countReserved) as T
       }
   }
   ```

3. 在`MainActivity`中，将count存储在本地，并构建带参数的 ViewModel:

   ```kotlin
   class MainActivity : AppCompatActivity() {
   
       companion object {
           const val COUNT_RESERVED = "count_reserved"
       }
   
       lateinit var viewModle: MainViewModel
       lateinit var sp: SharedPreferences
   
       override fun onCreate(savedInstanceState: Bundle?) {
           super.onCreate(savedInstanceState)
           setContentView(R.layout.activity_main)
   
           sp = getPreferences(Context.MODE_PRIVATE)
           val countReserved = sp.getInt(COUNT_RESERVED, 0)
           viewModle = ViewModelProviders.of(this,
               MainViewModelFactory(countReserved)).get(MainViewModel::class.java)
           plusOneBtn.setOnClickListener {
               viewModle.counter ++
               updateTextInfo()
           }
           clearBtn.setOnClickListener {
               viewModle.counter = 0
               updateTextInfo()
           }
           updateTextInfo()
       }
   
       override fun onPause() {
           super.onPause()
           sp.edit {
               putInt(COUNT_RESERVED, viewModle.counter)
           }
       }
   
       private fun updateTextInfo() {
           infoText.text = viewModle.counter.toString()
       }
   }
   ```

这样，即使app关闭，再打开count也不会丢失了：

<img src="https://i.loli.net/2020/04/26/H2IoUMbfOT3Yndt.png" alt="image-20200426192103761" style="zoom: 25%;" />

## 13.3 LifeCycle

1. 新建`MyObserve`类：

   ```kotlin
   class MyObserve(val lifecycle: Lifecycle): LifecycleObserver {
   
       @OnLifecycleEvent(Lifecycle.Event.ON_START)
       fun activityStart() {
           Log.d("MyObserve", "activityStart\nlifecycle currentState:${lifecycle.currentState}")
   
       }
   
       @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
       fun activityStop() {
           Log.d("MyObserve", "activityStop")
       }
   }
   ```

2. 在 Activity 中建立关联：

   ```kotlin
   class MainActivity : AppCompatActivity() {
   
       override fun onCreate(savedInstanceState: Bundle?) {
           ...
           lifecycle.addObserver(MyObserve(lifecycle))
       }
   }
   ```



## 13.4 Live Data

**作用**：在数据发生变化的时候，通知给观察者

修改`MainViewModel`类：

```kotlin
class MainViewModel(countReserved: Int = 0) : ViewModel() {

    val counter: LiveData<Int>
        get() = _counter
    private val _counter = MutableLiveData<Int>()

    init {
        _counter.value = countReserved
    }

    fun plusOne() {
        val count = counter.value ?: 0
        _counter.value = count + 1
    }

    fun clear() {
        _counter.value = 0
    }
}
```

然后调用部分可以如下改写，当counter放生变化时，回调，text文本及时更新。

```kotlin
viewModle.counter.observe(this, Observer {
            infoText.text = it.toString()
        })
```

完整代码：

```kotlin
class MainActivity : AppCompatActivity() {

    companion object {
        const val COUNT_RESERVED = "count_reserved"
    }

    lateinit var viewModle: MainViewModel
    lateinit var sp: SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        sp = getPreferences(Context.MODE_PRIVATE)
        val countReserved = sp.getInt(COUNT_RESERVED, 0)
        viewModle = ViewModelProviders.of(
            this,
            MainViewModelFactory(countReserved)
        ).get(MainViewModel::class.java)
        plusOneBtn.setOnClickListener {
            viewModle.plusOne()
        }
        clearBtn.setOnClickListener {
            viewModle.clear()
        }
        viewModle.counter.observe(this, Observer {
            infoText.text = it.toString()
        })
        
    }

    override fun onPause() {
        super.onPause()
        sp.edit {
            putInt(COUNT_RESERVED, viewModle.counter.value ?: 0)
        }
    }

    private fun updateTextInfo() {
        infoText.text = viewModle.counter.toString()
    }
}
```

### 13.4.2 map和swithMap

#### map

假如live有多个字段，但只想暴露个别的给别人用，就可以用map转换一下

新建 User 类：

```kotlin
class User(var firstName: String, var lastName: String,
var age: Int) {
}
```

在 ViewModel 中，就可以这样使用：

```kotlin
private val userLiveData = MutableLiveData<User>()
val userName: LiveData<String> = Transformations.map(userLiveData) {
    "${it.firstName} ${it.lastName}"
}
```

#### switchMap

###### 有参数

当数据不是由自己创建，而是由外部创建的时候，需要用到 switchMap 

在 ViewModel 中添加如下代码：

```kotlin
private val userIdLiveData = MutableLiveData<String>()

val user: LiveData<User> = Transformations.switchMap(userIdLiveData) {
    Repository.getUser(it)
}

fun getUser(userId: String) {
        userIdLiveData.value = userId
}
```

在 Activity 中如下调用：

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    ...
    getUserBtn.setOnClickListener {
        val userId = (0..10000).random().toString()
        viewModle.getUser(userId)
    }
    viewModle.user.observe(this, Observer {
        infoText.text = it.firstName
    })
}
```

###### 无参数

ViewModel 中的代码：

```kotlin
/* 无参的方法 */

private val refreshLiveData = MutableLiveData<Any?>()

val refreshResult = Transformations.switchMap(refreshLiveData) {
    Repository.refresh()
}
fun refresh() {
    refreshLiveData.value = refreshLiveData.value
}
```

Activity 中的调用：

```kotlin
/*刷新*/
refreshBtn.setOnClickListener {
    viewModle.refresh()
}
viewModle.refreshResult.observe(this, Observer {
    infoText.text = it.firstName
})
```

效果图：

<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ge85lz2f7mj30as0imjrx.jpg" alt="image-20200427111553331" style="zoom:67%;" />

## 13.5 Room

### 13.5.1 使用Room进行增删改查

Room主要由以下3部分组成：

- Entity
- Dao（Data Access Object）
- Database

引入插件、依赖：

```kotlin
...
apply plugin: 'kotlin-kapt'
...
dependencies {
    ...
    implementation 'androidx.room:room-runtime:2.2.5'
    kapt "androidx.room:room-compiler:2.2.5"
}
```



新建一个 User 类：

```kotlin
@Entity
data class User(var firstName: String, var lastName: String, var age: Int) {
    @PrimaryKey(autoGenerate = true)
    var id: Long = 0
}
```

新建抽象类`AppDatabase`：

```kotlin
@Database(version = 1, entities = [User::class])
abstract class AppDatabase : RoomDatabase() {

    abstract fun userDao(): UserDao

    companion object {
        private var instance: AppDatabase? = null

        @Synchronized
        fun getDatabase(context: Context): AppDatabase {
            instance?.let {
                return it
            }
            return Room.databaseBuilder(context.applicationContext,
                AppDatabase::class.java, "app_database")
          			.allowMainThreadQueries() // 允许在主线程中操作数据库，建议只在测试环境下使用
                .build().apply {
                instance = this
            }
        }
    }
}
```

然后就可以使用了

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    val userDao = AppDatabase.getDatabase(this).userDao()
    val user1 = User("Tom", "Brady", 40)
    val user2 = User("Tom", "Hanks", 63)
    addDataBtn.setOnClickListener {
        thread {
            user1.id = userDao.insertUser(user1)
            user2.id = userDao.insertUser(user2)
        }
    }
    updateDataBtn.setOnClickListener {
        thread {
            user1.age = 42
            userDao.updateUser(user1)
        }
    }
    deleteDataBtn.setOnClickListener {
        thread {
            userDao.deleteUserByLastName("Hanks")
        }
    }
    queryDataBtn.setOnClickListener {
        thread {
            for (user in userDao.loadAllUsers()) {
                Log.d("MainActivity", user.toString())
            }
        }
    }
}
```

### 13.5.2 Room的数据库升级

#### Version2 

> 增加了Book表
>

定义 Book Entity:

```kotlin
@Entity
class Book(var name: String, var pages: Int) {
    @PrimaryKey(autoGenerate = true)
    var id: Int = 0
}
```

新建 Book Dao:

```kotlin
@Dao
interface BookDao {

    @Insert
    fun insertBook(book: Book): Long
    
    @Query("select * from Book")
    fun loadAllBooks(): List<Book>
}
```

修改`AppDatabase`:

```kotlin
@Database(version = 2, entities = [User::class, Book::class])
abstract class AppDatabase : RoomDatabase() {

  	...
    abstract fun bookDao(): BookDao

    companion object {

        val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(database: SupportSQLiteDatabase) {
                database.execSQL("" +
                        "create table Book(" +
                        "id integer primary key autoincrement not null," +
                        "name text not null, " +
                        "pages integer not null)")
            }
        }

        ...

        @Synchronized
        fun getDatabase(context: Context): AppDatabase {
            instance?.let {
                return it
            }
            return Room.databaseBuilder(context.applicationContext,
                AppDatabase::class.java, "app_database")
                .addMigrations(MIGRATION_1_2)
                .build().apply {
                instance = this
            }
        }
    }
}
```

#### Version3

> Book 表增加 author 字段

1. Book 类加上`author`属性

   ```kotlin
   class Book(var name: String, var pages: Int, var author: String) {
       @PrimaryKey(autoGenerate = true)
       var id: Int = 0
   }
   ```

2. 修改版本号为3

   ```kotlin
   @Database(version = 3, entities = [User::class, Book::class])
   ```

3. 编写升级部分的数据库sql语句

   ```kotlin
   val MIGRATION_2_3 = object : Migration(2, 3) {
       override fun migrate(database: SupportSQLiteDatabase) {
           database.execSQL("" +
                   "alter table Book add column author text not null default 'unknown'")
       }
   }
   ```

4. 调用sql语句

   ```kotlin
   @Synchronized
           fun getDatabase(context: Context): AppDatabase {
               instance?.let {
                   return it
               }
               return Room.databaseBuilder(context.applicationContext,
                   AppDatabase::class.java, "app_database")
                   .addMigrations(MIGRATION_1_2, MIGRATION_2_3)
                   .build().apply {
                   instance = this
               }
           }
   ```

完整`AppDatabase`代码：

```kotlin
@Database(version = 3, entities = [User::class, Book::class])
abstract class AppDatabase : RoomDatabase() {

    abstract fun userDao(): UserDao
    abstract fun bookDao(): BookDao

    companion object {

        private val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(database: SupportSQLiteDatabase) {
                database.execSQL("" +
                        "create table Book(" +
                        "id integer primary key autoincrement not null," +
                        "name text not null, " +
                        "pages integer not null)")
            }
        }

        val MIGRATION_2_3 = object : Migration(2, 3) {
            override fun migrate(database: SupportSQLiteDatabase) {
                database.execSQL("" +
                        "alter table Book add column author text not null default 'unknown'")
            }
        }

        private var instance: AppDatabase? = null

        @Synchronized
        fun getDatabase(context: Context): AppDatabase {
            instance?.let {
                return it
            }
            return Room.databaseBuilder(context.applicationContext,
                AppDatabase::class.java, "app_database")
//                .allowMainThreadQueries()
//                .fallbackToDestructiveMigration() // 暴力重建数据库，只能在开发测试阶段使用
                .addMigrations(MIGRATION_1_2, MIGRATION_2_3)
                .build().apply {
                instance = this
            }
        }
    }
}
```



## 13.6 WorkManager

### 13.6.1 WorkManager 的基本用法

```kotlin
class SimpleWorker(context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {
    override fun doWork(): Result {
        Log.d("SimpleWorker", "do work in SimpleWorker")
        return Result.success()
    }
}
```

调用：

```kotlin
doWorkBtn.setOnClickListener {
        val request = OneTimeWorkRequest.Builder(SimpleWorker::class.java).build()
        WorkManager.getInstance(this).enqueue(request)
    }
}
```

### 13.6.2 使用 WorkManager 处理复杂的任务

1. 添加 tag、添加 retry 的时间

   ```kotlin
   doWorkBtn.setOnClickListener {
       val request = OneTimeWorkRequest.Builder(SimpleWorker::class.java)
               .setInitialDelay(5, TimeUnit.SECONDS) // 设置延迟时间
               .addTag("simple") // 添加标签，之后根据需要可以根据标签来取消任务
               .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 10, TimeUnit.SECONDS) // 设置返回 retry 的重新执行时间
               .build()
       WorkManager.getInstance(this).enqueue(request)
   ```

2. 取消任务：

   ```kotlin
   				/*取消*/
               // 取消指定tag的
           WorkManager.getInstance(this).cancelAllWorkByTag("simple")
               // 取消全部
           WorkManager.getInstance(this).cancelAllWork()
   ```

3. 对执行结果的监听：

   ```kotlin
   WorkManager.getInstance(this)
           .getWorkInfoByIdLiveData(request.id) // 还可以根据标签获取任务
           .observe(this, Observer {
               if (it.state == WorkInfo.State.SUCCEEDED) {
                   Log.d("MainActivity", "do work  succeeded")
               } else if (it.state == WorkInfo.State.FAILED) {
                   Log.d("MainActivity", "do work  failed")
               }
           })
   ```

4. 链式任务

5. ```kotlin
   /*链式任务*/
   val sync = ...
   val compress = ...
   val upload = ...
   WorkManager.getInstance(this)
           .beginWith(sync)
           .then(compress)
           .then(upload)
           .enqueue()
   ```

   但在国产手机上，被一键杀死后，会失效，不要来处理核心任务



## 13.7 Kotlin 课堂：使用DSL构建专有的语法结构

DSL全称：Domain Specific Language 

> 它是编程语言赋予开发者的一种特殊能力，通过它我们可以编写出一些看似脱离其原始语法结构的代码，从而构建出一种专有的语法结构



  实现一个简单的 DSL ：

```kotlin
class Dependencies {

    val libraries = ArrayList<String>()

    fun implementation(lib: String) {
        libraries.add(lib)
    }
}

fun dependencies(block: Dependencies.() -> Unit): ArrayList<String> {
    val dependencies = Dependencies()
    dependencies.block()
    return dependencies.libraries
}

fun main() {
    val libraries = dependencies {
        implementation("com.foo:foo:2.1")
        implementation("com.bar:bar:3.5")
    }
    for (lib in libraries) {
        println(lib)
        /*
        com.foo:foo:2.1
        com.bar:bar:3.5
        */
    }
}
```



实现一个复杂的DSL：

用与构建 Html 中的 table 代码，完整示例：

```kotlin
class Td {
    var content = ""
    fun html() = "\n\t\t<td>$content</td>"
}

class Tr {
    val tdList = ArrayList<Td>()

    fun td(block: Td.() -> String) {
        val td = Td()
        td.content = td.block()
        tdList.add(td)
    }

    fun html(): String {
        val builder = StringBuilder()
        builder.append("\n\t<tr>")
        for (td in tdList) {
            builder.append(td.html())
        }
        builder.append("\n\t</tr>")
        return builder.toString()
    }
}

fun table(block: Table.() -> Unit): String {
    val table = Table()
    table.block()
    return table.html()
}

class Table {
    val trList = ArrayList<Tr>()

    fun tr(block: Tr.() -> Unit) {
        val tr = Tr()
        tr.block()
        trList.add(tr)
    }

    fun html(): String {
        val builder = StringBuilder()
        builder.append("\n<table>")
        for (tr in trList) {
            builder.append(tr.html())
        }
        builder.append("\n</table>\n")
        return builder.toString()
    }
}

fun main() {
    val tr = Tr()
    tr.td { "Item 1" }
    tr.td { "Item 2" }
    tr.td { "Item 3" }

    val table = Table()
    table.tr {
        td { "A" }
        td { "B" }
        td { "C" }
    }
    table.tr {
        td { "1" }
        td { "2" }
        td { "3" }
    }

    val tableHtml = table {
        tr {
            td { "1⃣️" }
            td { "2⃣️️" }
            td { "三" }
        }
        tr {
            td { "五" }
            td { "6" }
            td { "7" }
        }
    }
    println(tableHtml)
}
```

DSL 用起来真爽😄

