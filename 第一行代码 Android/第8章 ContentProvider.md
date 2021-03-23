### 8.2.2 在程序运行时申请权限

拿拨打电话举例子

1⃣️首先在 Manifest 中声名权限

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.zanyzephyr.runtimepermissiontest">

    <uses-permission android:name="android.permission.CALL_PHONE" />
    ...
</manifest>
```

2⃣️ 抽取拨打电话的方法：

```xml
private fun call() {
    try {
        val intent = Intent(Intent.ACTION_CALL)
        intent.data = Uri.parse("tel:10010")
        startActivity(intent)
    } catch (e: SecurityException) {
        e.printStackTrace()
    }
}
```

3⃣️点击拨打按钮先进行权限判断

​	如果：

​		（1）没有权限，申请权限；

​		（2）有权限，则调用拨打电话方法

```kotlin
makeCall.setOnClickListener {
    /* 先检查是否有权限，有的话，拨打电话，没有的话去申请权限 */
    if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CALL_PHONE) !=
            PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this,
        arrayOf(android.Manifest.permission.CALL_PHONE), 1)
    } else {
        call() // 拨打电话
    }
}
```



在权限申请的回调中，（1）如果申请到了权限，则拨打电话；（2）被拒绝的话，给出提示

```kotlin
override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    when (requestCode) {
        1 -> {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                call()
            } else {
                Toast.makeText(this, "You denied the permission", Toast.LENGTH_LONG).show()
            }
        }
    }
}
```

​	

## 8.3 访问其他程序中的数据

```kotlin
fun testContentProvider() {
    val uri = Uri.parse("content://com.example.provider/table1")

    /* 查询 */
    val cursor = contentResolver.query(
        uri,
        projection, // select column1, column2
        selection, // where column = value
        selectionArgs, // - 为where中的占位符提供具体的值
        sortOrder // 排序方式
    )
    if (cursor != null) {
        while (cursor.moveToNext()) {
            val column1 = cursor?.getString(cursor.getColumnIndex("column1"))
        }
        cursor.close()
    }

    /* 插入 */
    val values = contentValuesOf("column1" to "text", "column2" to 1)
    contentResolver.insert(uri, values)

    /* 更新 update*/
    val value2 = contentValuesOf("column1" to "")
    contentResolver.update(uri, value2, "column1 = ? and column2 = ?", arrayOf("text", "1"))

    /* 删除 */
    contentResolver.delete(uri, "column2 = ?", arrayOf("1"))
}
```

### 8.4 创建自己的ContentProvider

### 8.4.1 创建 ContentProvider 的步骤

新建 `DatabaseProvider`: New -> Other -> Content Provider

```kotlin
class DatabaseProvider : ContentProvider() {

    private val bookDir = 0
    private val bookItem = 1
    private val categoryDir = 2
    private val categoryItem = 3
    private val authority = "com.zanyzephyr.databasetest.provider"
    private var dbHelper: SQLiteOpenHelper? = null

    private val uriMatcher by lazy {
        val matcher = UriMatcher(UriMatcher.NO_MATCH)
        matcher.addURI(authority, "book", bookDir)
        matcher.addURI(authority, "book/#", bookItem)
        matcher.addURI(authority, "category", categoryDir)
        matcher.addURI(authority, "category/#", categoryItem)
        matcher
    }

    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?) =
        dbHelper?.let {
            val db = it.writableDatabase
            val deletedRows = when (uriMatcher.match(uri)) {
                bookDir -> db.delete("Book", selection, selectionArgs)
                bookItem -> db.delete("Book", "id = ?", arrayOf(uri.pathSegments[1]))
                categoryDir -> db.delete("Category", selection, selectionArgs)
                categoryItem -> db.delete("Category", "id = ?", arrayOf(uri.pathSegments[1]))
                else -> 0
            }
            deletedRows
        } ?: 0

    override fun getType(uri: Uri) = when (uriMatcher.match(uri)) {
        bookDir -> "vnd.android.cursor.dir/vnd.com.zanyzephyr.databasetest.provider.book"
        bookItem -> "vnd.android.cursor.item/vnd.com.zanyzephyr.databasetest.provider.book"
        categoryDir -> "vnd.android.cursor.dir/vnd.com.zanyzephyr.databasetest.provider.category"
        categoryItem -> "vnd.android.cursor.item/vnd.com.zanyzephyr.databasetest.provider.category"
        else -> null
    }

    override fun insert(uri: Uri, values: ContentValues?) = dbHelper?.let {
        val db = it.writableDatabase
        val uriReturn = when (uriMatcher.match(uri)) {
            bookDir, bookItem -> {
                val newBookId = db.insert("Book", null, values)
                Uri.parse("content://$authority/book/$newBookId")
            }
            categoryDir, categoryItem -> {
                val categoryId = db.insert("Category", null, values)
                Uri.parse("content://$authority/category/$categoryId")
            }
            else -> null

        }
        uriReturn
    }


    override fun onCreate() = context?.let {
        dbHelper = SQLiteOpenHelper(it, "BookStore.db", 2)
        true
    } ?: false

    override fun query(
        uri: Uri, projection: Array<String>?, selection: String?,
        selectionArgs: Array<String>?, sortOrder: String?
    ) = dbHelper?.let {
        // 查询数据
        val db = it.readableDatabase
        val cursor = when (uriMatcher.match(uri)) {
            bookDir -> db.query(
                "Book", projection, selection, selectionArgs, null, null,
                sortOrder
            )
            bookItem -> {
                val bookId = uri.pathSegments[1]
                db.query(
                    "Book", projection, "id = ?", arrayOf(bookId), null, null,
                    sortOrder
                )
            }
            categoryDir -> db.query(
                "Category", projection, selection, selectionArgs, null, null,
                sortOrder
            )
            categoryItem -> {
                val categoryId = uri.pathSegments[1]
                db.query(
                    "Category", projection, "id = ?", arrayOf(categoryId), null, null,
                    sortOrder
                )
            }
            else -> null
        }
        cursor
    }

    override fun update(
        uri: Uri, values: ContentValues?, selection: String?,
        selectionArgs: Array<String>?
    ) = dbHelper?.let {
        // 更新数据
        val db = it.writableDatabase
        val updateRow = when (uriMatcher.match(uri)) {
            bookDir -> db.update("Book", values, selection, selectionArgs)
            bookItem -> {
                val bookId = uri.pathSegments[1]
                db.update("Book", values, "id = ?", arrayOf(bookId))
            }
            categoryDir -> db.update("Category", values, selection, selectionArgs)
            categoryItem -> {
                val categoryId = uri.pathSegments[1]
                db.update("Category", values, "id = ?", arrayOf(categoryId))
            }
            else -> 0
        }
        updateRow
    } ?: 0
}
```

会自动在 `manifest`中注册：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.zanyzephyr.databasetest">

    <application
        ...>
        <provider
            android:name=".DatabaseProvider"
            android:authorities="com.zanyzephyr.databasetest.provider"
            android:enabled="true"
            android:exported="true"></provider>
						...
    </application>

</manifest>
```



### 8.4.2 实现跨程序数据共享

```kotlin
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var bookId: String? = null
        val uriString = "content://com.zanyzephyr.databasetest.provider/book"

        addData.setOnClickListener {
            // 添加数据
            val uri = Uri.parse(uriString)
            val values = contentValuesOf(
                "name" to "A Clash of Kings",
                "author" to "George Martin",
                "page" to 1040,
                "price" to 22.85
            )
            val newUri = contentResolver.insert(uri, values)
            bookId = newUri?.pathSegments?.get(1)
            Log.d("MainActivity", "book added, book id: $bookId")
        }
        queryData.setOnClickListener {
            contentResolver.query(Uri.parse(uriString), null, null, null, null)?.apply {
                Log.d("MainActivity", "query result: ${this.count}")
                while (moveToNext()) {
                    val name = getString(getColumnIndex("name"))
                    val author = getString(getColumnIndex("author"))
                    val page = getString(getColumnIndex("page"))
                    val price = getString(getColumnIndex("price"))
                    Log.d("MainActivity", "book name is $name")
                    Log.d("MainActivity", "book author is $author")
                    Log.d("MainActivity", "book page is $page")
                    Log.d("MainActivity", "book price is $price")
                }
                close()
            }
        }
        updateData.setOnClickListener {
            // 更新数据
            bookId?.let {
                val newUri = Uri.parse("$uriString/$it")
                val values = contentValuesOf("name" to "A Storm of Swords",
                "page" to 1216, "price" to 24.05)
                contentResolver.update(newUri, values, null, null)
            }
        }
        deleteData.setOnClickListener {
            bookId?.let {
                val newUri = Uri.parse("$uriString/$it")
                contentResolver.delete(newUri, null, null)
            }
        }
    }
}
```

⚠️中间列的名字不能写错，不然就操作失败了😓



## 8.5 Kotlin课堂：泛型和委托

### 8.5.1 泛型的几本用法

#### 1⃣️定义一个泛型类

```kotlin
class GenericClass<T> {
    fun method(param: T): T {
        return param
    }
}

fun main() {
    val generic = GenericClass<Int>()
    generic.method(123)
}
```

#### 2⃣️只定义一个泛型方法

```kotlin
fun main() {
    val genericMethodClass = GenericMethodClass()
    genericMethodClass.method<Int>(456)
}

class GenericMethodClass {
    fun <T>method(param: T): T {
        return param
    }
}
```

3⃣️约束泛型的类型

##### <1>约束泛型的类型为`Number`：

```kotlin
fun <T: Number>methodWithNumber(param: T): T {
    return param
}
```

如下图所示，Double 可以，String 就报错了

![image-20200420093636200](https://tva1.sinaimg.cn/large/007S8ZIlly1gdzzekxfxpj30hm04vwex.jpg)

##### <2>约束泛型不为null

默认只写个<T>的时候，其实相当于 <T: Any?>，是可以为空的，就像下面的调用：

```kotlin
genericMethodClass.method(null)
```

但写个`<T:Any>`后就不能为null了：

![image-20200420094246371](https://tva1.sinaimg.cn/large/007S8ZIlly1gdzzkxstc9j30ai0290sp.jpg)

之前写的报错了：

![image-20200420094312435](https://tva1.sinaimg.cn/large/007S8ZIlly1gdzzleazklj30le03gjrq.jpg)

##### <3>实践 编写一个类似系统`apply`的方法

使用泛型来定义：

```kotlin
fun <T>T.build(block: T.() -> Unit): T {
    block()
    return this
}
```

然后就可以像调用`apply`一样调用自己的`build`了

例1:

```kotlin
contentResolver.query(Uri.parse(uriString), null, null, null, null)?.build {
    while (moveToNext()) {
        ...
    }
    close()
}
```

例2:

```kotlin
fun main() {
    val builder = StringBuilder()
    builder.build {
        append("a")
        append("b")
    }
    println("builder is : $builder") // builder is : ab
}
```

### 8.5.2 类委托和委托属性

**类委托**

不用类委托的写法

```kotlin
class MySet<T>(val helperSet: HashSet<T>): Set<T> {
    override val size: Int
        get() = helperSet.size

    override fun contains(element: T) =
        helperSet.contains(element)

    override fun containsAll(elements: Collection<T>) =
        helperSet.containsAll(elements)

    override fun isEmpty() =
        helperSet.isEmpty()

    override fun iterator() =
        helperSet.iterator()
}
```

用类委托之后的：

```kotlin
class MySet<T>(val helperSet: HashSet<T>): Set<T> by helperSet {

}
```

接着可以接着实现自己的方法，或覆盖某些方法：

```kotlin
class MySet<T>(val helperSet: HashSet<T>): Set<T> by helperSet {
    fun greeting(name: String) {
        println("Hello, $name!")
    }

    override fun isEmpty() = false
}
```

**属性委托**

一个简单的示例

```kotlin
class MyClass {
    var property by Delegate()
}

class Delegate {
    operator fun getValue(myClass: MyClass, property: KProperty<*>): Any? {
        return propValue
    }

    operator fun setValue(myClass: MyClass, property: KProperty<*>, any: Any?) {
        propValue = any
    }

    var propValue: Any? = null

}
```

### 8.5.3 实现一个自己的lazy函数

`Later.kt`文件中实现：

```kotlin
class Later<T>(val block: () -> T) {
    var value: Any? = null

    operator fun getValue(any: Any?, prop: KProperty<*>): T {
        if (value == null) {
            value = block()
        }
        return value as T
    }
}

fun <T> later(block: () -> T) = Later(block)
```

然后在 `Activity`中点击按钮调用懒加载的属性：

```kotlin
private val str by later {
    Log.d("TAG", "run codes inside later block")
    "test later"
}
override fun onCreate(savedInstanceState: Bundle?) {
    ..
    button.setOnClickListener {
        println("str: $str") 
      /* 点击按钮后才会打印
      D/TAG: run codes inside later block
      */
    }
}
```

