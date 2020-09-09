### 2.3.2 函数

类比 Swift，Kotlin 能做到更简单，可以简单到不写 {}，不写 return，不写函数的返回值

比如 Swift 下的

```swift
func largeNumber(num1: Int, num2: Int) -> Int {
		return max(num1, num2)
}
```

Kotlin 的最简写法为：

```kotlin
fun largeNumber(num1: Int, num2: Int) = max(num1, num2)
```



### 2.4.1  if 条件语句

Kotlin 的 if 比较特别的地方，是可以有返回值

```kotlin
fun largeNumberV2(num1: Int, num2: Int) = if (num1 > num2) num1 else num2
```

> *百度了一下，Kotlin中没有三目运算符，以上这种写法就很类似于三目运算符了*



### 2.4.2 when 条件语句

#### （1）常规用法

相当于 Swift 下的 ```switch```

示例：

```kotlin
fun getScore(name: String): Int {
    return when (name) {
        "Tom" -> 86
        "Jim" -> 77
        "Jack" -> 95
        "Lily" -> 100
        else -> 0
    }
}
```

#### (2)另外，Kotlin 中的 when，还支持类型匹配，例如：

```kotlin
fun checkNumber(num: Number) {
    when (num) {
        is Int -> println("number is Int")
        is Double -> println("number is Double")
        else -> println("number is not support")
    }
}
```

#### （3）不在when语句中传入参数

例如：

```kotlin
fun getScoreV2(name: String): Int {
    return when {
        name.startsWith("Tom") -> 86
        name == "Jim" -> 77
        name == "Jack" -> 95
        name == "Lily" -> 100
        else -> 0
    }
}
```

### 2.4.3 循环语句

详细如下

```kotlin
    val rangeNormal = 0..10
    for (i in rangeNormal) {
        print("$i,") // 0,1,2,3,4,5,6,7,8,9,10,
    }
    println()
    val range = 0 until 10
    for (i in range) {
        print("$i,") // 0,1,2,3,4,5,6,7,8,9,
    }
    println()
    val rangeDown = 10 downTo 1
    for (i in rangeDown) {
        print("$i,") // 10,9,8,7,6,5,4,3,2,1,
    }
```

另外，还有关键字 step ：

```kotlin
val rangeWithStep = 0..10 step 2
for (i in rangeWithStep) {
    print("$i,") // 0,2,4,6,8,10,
}
```



### 2.5.2　继承与构造函数

#### （1）一个类默认是不可被继承的，如果想让该类可被继承，需要在前边加上 ```open``` 关键字：

```kotlin
open class Person {
    var name = ""
    var age = 0
    fun eat() {
        println("$name is eating. He is $age years old.")
    }
}
```

#### （2）继承父类的写法，和 Swift 写法差不多，也是用 ```:``` 进行标记的，但是后面加了一对括号 ```()```，意思是子类在实例化的时候，要执行父类的主构造函数

示例，创建 Student 类，继承自 Person 类：

```kotlin
class Student(val sno: String, val grade: Int): Person() {
    init {
        println("sno is $sno\ngrade is $grade")
    }
}
```

初始化一个 Student 实例：

```kotlin
val s = Student("110", 1)
```

#### （3）一个类都有一个且仅有一个主构造函数，可以有多个次构造函数。但是次构造函数必须直接或间接的调用主构造函数

示例：

```kotlin
class Student(val sno: String, val grade: Int, name: String, age: Int): Person(name, age){
    constructor(sno: String, grade: Int): this(sno, grade, "", 0) {

    }
    constructor(): this("110", -1) {

    }
}
```

初始化：

```kotlin
val s = Student("110", 5, "李懿哲", 30)
val s1 = Student("120", 1)
val s2 = Student()
```

引用原书的说明：

> 次构造函数是通过constructor关键字来定义的，这里我们定义了两个次构造函数：第一个次构造函数接收name和age参数，然后它又通过this关键字调用了主构造函数，并将sno和grade这两个参数赋值成初始值；第二个次构造函数不接收任何参数，它通过this关键字调用了我们刚才定义的第一个次构造函数，并将name和age参数也赋值成初始值，由于第二个次构造函数间接调用了主构造函数，因此这仍然是合法的。

#### （4）父类后不加 ```()```的情况

```kotlin
class Student : Person {
    constructor(name: String, age: Int) : super(name, age) {
    }
}
```

因为没有声名主构造函数，所以次构造函数不用也无法调用自己的主构造函数了，只能用 ```super``` 调用父类的构造函数了

引用原书的说明：

> 注意这里的代码变化，首先Student类的后面没有显式地定义主构造函数，同时又因为定义了次构造函数，所以现在Student类是没有主构造函数的。那么既然没有主构造函数，继承Person类的时候也就不需要再加上括号了。其实原因就是这么简单，只是很多人在刚开始学习Kotlin的时候没能理解这对括号的意义和规则，因此总感觉继承的写法有时候要加上括号，有时候又不要加，搞得晕头转向的，而在你真正理解了规则之后，就会发现其实还是很好懂的。

### 2.5.3 

修饰符：

| **修饰符** | 可见性             |
| ---------- | :----------------- |
| public     | 所有类可见（默认） |
| private    | 当前类可见         |
| protected  | 当前类、子类可见   |
| internal   | 同一模块中的类可见 |



### 2.5.4 数据类与单例类

#### （1）数据类

写法很简单，在 ```class``` 前，加上关键字 ```data``` 就可以了：

```kotlin
data class Cellphone(val brand: String, val price: Double)
```

```kotlin
val cellphone1 = Cellphone("iPhone", 4999.0)
val cellphone2 = Cellphone("iPhone", 4999.0)
print("cellphone1 == cellphone2 ? " + (cellphone1 == cellphone2))
// cellphone1 == cellphone2 ? true
```

### （2）单例

kotlin 的单例是我见过最简单方便的，只用把关键字```class```换成```object```就可以了，也没有参数体：

```kotlin
object Singleton {
    fun share(type: String) {
        println("share to $type")
    }
}
```

调用：

```kotlin
Singleton.share("微信") // share to 微信
val s = Singleton
val s2 = Singleton
println("s == s2? " + (s == s2)) // s == s2? true
```

### 2.6.1 集合的创建与遍历

#### （1）不可变集合

```kotlin
val list = listOf("Apple", "Banana", "Orange", "Pear", "Grape")
for (fruit in list) {
    println(fruit)
}
```

#### （2）可变集合

```kotlin
val mList = mutableListOf("Apple", "Banana", "Orange", "Pear", "Grape")
mList.add("Watermelon")
for (fruit in mList) {
    println(fruit)
}
```

#### （3）map

和Swift很相似

**声名：**

```kotlin
val map = hashMapOf<String, Int>()
map["Apple"] = 1
map["Banana"] = 2
map["Orange"] = 3

val map2 = mutableMapOf("Apple" to 1, "Banana" to 2)
map2["Orange"] = 3
```

**取值：**

```kotlin
for ((fruit, number) in map) {
    println("$fruit's number is $number")
}
```



### 2.6.2 集合的函数式API

Lambda表达式

```kotlin
val list = listOf<String>("Apple", "Banana", "Orange")
```

找出最大的：

```kotlin
val maxItem = list.maxBy { it.length }
println(newList) // Banana
```

全部转换成大写：

```kotlin
val newList = list.map { it.toUpperCase() }
println(newList) // [APPLE, BANANA, ORANGE]
```

filter的简单使用：

```kotlin
val newList = list.filter { it.length <= 5 }
println(newList) // [APPLE]
```

any和all的用法，前者满足一个就为true，后者要满足所有才为true

```kotlin
    val list = listOf<String>("Apple", "Banana", "Orange", "Pear", "Grape", "Watermelon")
    val anyResult = list.any { it.length <= 5 }
    val allResult = list.all { it.length <= 5 }
    println("anyResult is $anyResult, allResult is $allResult") 
		// anyResult is true, allResult is false
```



### 2.6.3　Java函数式API的使用

新建一个thread：

```kotlin
Thread{
    println("thread is start.")
}.start()
```

在kotlin中设置一个按钮的监听：

```kotlin
button.setOnClickListener {
}
```



## 2.7　空指针检查

和Swift有点像，用？来表示可能为空

```kotlin
fun doStudy(study: Study?) {
    study?.readBooks()
}
doStudy(null)
```



### 2.7.2　判空辅助工具

#### （1）

这个是Swift没有的： ```?:```，用法如下：

```kotlin
val a = null
val b = "b"
val c = a ?: b
println(c) // b
```

```?```和```?:```连着用：

```kotlin
fun main() {
    println(getTextLength(null)) // 0
}

fun getTextLength(text: String?) = text?.length ?: 0
```

#### （2）

Swift中的强制拆包，用```!```，Kotlin中用的是```!!```

#### （3）

？还可以配合Kotlin中的let使用：

```kotlin
fun doStudy(study: Study?) {
    study?.let {
        it.readBooks()
        it.doHomework()
    }
}
```



## 2.8　Kotlin中的小魔术

### 2.8.1　字符串内嵌表达式

Swift中是```"\()"```

Kotlin中是"${}"，如果花括号中只有一个变量时，可以省略花括号：

```kotlin
val a = 1
val b = 2
println("$a") // 1
println("result: ${a + b}") // result: 3
```

### 2.8.2　函数的参数默认值



