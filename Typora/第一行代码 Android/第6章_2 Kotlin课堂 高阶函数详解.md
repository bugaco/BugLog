### /6.5.1 定义高阶函数

简单用法：

```kotlin
fun operator(num1: Int, num2: Int, func: ((Int, Int) -> Int)) {
    println(func(num1, num2))
}

fun plus(num1: Int, num2: Int): Int {
    return num1 + num2
}

fun times(num1: Int, num2: Int): Int {
    return num1 * num2
}

fun main() {
    operator(2, 3, ::times) // 6
    operator(5, 6, ::plus) // 11

    operator(8, 9) { n1, n2 ->
        n1 - n2 // -1
    }
    operator(4, 7) { n1, n2 ->
        n2 / n1 // 1
    }
}
```

模仿`apply`函数：

```kotlin
fun main() {
    operator(2, 3, ::times)
    operator(5, 6, ::plus)

    operator(8, 9) { n1, n2 ->
        n1 - n2
    }
    operator(4, 7) { n1, n2 ->
        n2 / n1
    }

    var stringBuilder = StringBuilder().build {
        append("1a")
        append("b2")
    }
    println("stringBuilder: $stringBuilder")
}

fun StringBuilder.build(block: StringBuilder.() -> Unit): StringBuilder {
    block()
    return this
}
```

⚠️这个函数类型参数的声明方式和我们前面学习的语法有所不同：它在函数类型的前面加上了一个 `StringBuilder.` 的语法结构。在函数类型的前面加上`ClassName.`就表示这个函数类型是定义在哪个类当中的。

这里定义到StringBuilder`类当中，当调用 build 函数时传入的 Lambda 表达式会自动拥有 StringBuilder 的上下文，这也是 apply 函数的实现方式

自己练习，定义了如下类和实现，相比 build ，更简单，主要是想体验下新的用法：

```kotlin
fun Animal.doSomething(block: Animal.() -> Unit) {
    block()
}

class Animal {
  
    fun eat(food: String) {
        println("Animal eat $food.")
    }

    fun cry() {
        println("Animal cry.")
    }
}

fun main() {
    val dog = Animal()
    dog.doSomething {
        println("nothing")
        repeat(2) {
            eat("💩")
        }
        cry()
    }
}
```

### 6.5.2 内敛函数的作用

内联函数 `inline`的工作原理：

> Kotlin 编译器会将内联函数中的代码在编译的时候自动替换到调用它的地方，这样就不存在运行时的开销了

```kotlin
inline fun Animal.doSomething(block: Animal.() -> Unit) {
    block()
}
```

### 6.5.3 noinline 与 crossinline

#### noinline

这个容易理解一些：inline 修饰的高阶函数中， noinline 修饰某个函数后，告诉编译器不对该表达式进行内联

```kotlin
inline fun Animal.doSomething(noinline block: Animal.() -> Unit) {
    block()
}
```

⚠️内联函数和非内联函数还有个重要区别：

- 内联函数引用的 Lambda 表达式中可以使用 return 进行函数返回
- 非内联函数只能进行局部返回

```kotlin
fun printString(str: String, block: (String) -> Unit) {
    println("printString begin")
    block(str)
    println("printString end")
}

fun main() {
    println("main start")
    val str = ""
    printString(str) {
        println("lambda start")
        if (it.isEmpty()) return@printString
        print(it)
        println("lambda end")
    }
    println("main end")
}
```

上面的代码，return 进行了局部返回，只是终止了 lambda 表达式的执行，main 函数回继续执行，所以输出如下

```kotlin
/**
main start
printString begin
lambda start
printString end
main end
*/
```



如果改成内联函数，进行代码替换的话，则可以直接使用 return 关键字：

```kotlin
inline fun printString(str: String, block: (String) -> Unit) {
    println("printString begin")
    block(str)
    println("printString end")
}

fun main() {
    println("main start")
    val str = ""
    printString(str) {
        println("lambda start")
        if (it.isEmpty()) return
        print(it)
        println("lambda end")
    }
    println("main end")
}
```

因为替换了代码，return 执行的时候，main 函数直接 return 了，输出如下：

```kotlin
/**
main start
printString begin
lambda start
*/
```



#### crossinline

参考以下代码：

```kotlin
inline fun runRunRunnable(crossinline block: () -> Unit) {
    val runnable = Runnable {
        block()
    }
    runnable.run()
}
```

> 之所以加上`crossinline`，是因为内联函数的 Lambda 表达式中允许 return 关键字，高阶函数的匿名类实现中不允许使用 return 关键字，这样就冲突了，所以 需要加上`crossinline`保证 block 中没有 return。加上`crossinline`后，如果 block 中有 return 关键字，编译器会报错。

经过自己test，发现不用太操心自己写错，需要加`crossinline`的时候，IDE会自动提示你，即使写错也编译不通过



