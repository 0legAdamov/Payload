[/]:# (https://gist.github.com/MinhasKamal/7fdebb7c424d23149140#file-github-markdown-syntax-md)

[/]:# (stackedit.io)

## Operators
### [Ignoring ](#ignoring)
* [ignoreElements](#ignoreelements)
* [elementAt](#elementat)
* [filter](#filter)
### [Skipping ](#skipping)
* [skip](#skip)
* [skipWhile](#skipwhile)
* [skipUntil](#skipuntil)
### [Taking ](#taking)
* [take](#take)
* [takeWhile](#takewhile)
* [takeUntil](#takeuntil)
### [Distinct ](#distinct)
* [distinctUntilChanged](#distinctuntilchanged)
### [Transforming ](#transforming)
* [toArray](#toarray)
* [map](#map)
* [flatMap](#flatmap)
* [flatMapLatest](#flatmaplatest)
* [materialize & dematerialize](#materialize-and-dematerialize)
### [Combining ](#combining)
* [startWith](#startwith)
* [concat](#concat)
* [concatMap](#concatmap)
* [merge](#merge)
* [combineLatest](#combinelatest)
* [zip](#zip)
### [Trigers ](#trigers)
* [withLatestFrom](#withlatestfrom)
* [sample](#sample)
### [Switches ](#switches)
* [amb](#amb)
* [switchLatest](#switchlatest)
### [Combining within sequence ](#combining-within-sequence)
* [reduce](#reduce)
* [scan](#scan)
***

## Ignoring
### ignoreElements

Игнорирует `.next`  и пропускает только `.completed` и 
`.error`
```swift
let subject = PublishSubject<String>()
subject.ignoreElements().subscribe { _ in 
	// print on .completed or .error
}.disposed(by: disposeBag)
```
### elementAt
Принимает события начиная с индекса
```swift
let subject = PublishSubject<String>()
subject.elementAt(2).subscribe(onNext: { string in 
	// start from third element
}).disposed(by: disposeBag)
```
### filter
Фильтрация каждого элемента
```swift
Observable.of(1,2,3,4,5,6)
	.filter { $0 % 2 == 0 }
	.subscribe(onNext: { element in 
		// 2, 4, 6
	}).disposed(by: disposeBag)
```
##### [Operators](#operators)
## Skipping
### skip
Пропускает `n` элементов, начиная с первого элемента
```swift
Observable.of("A", "B", "C", "D", "E", "F")
	.skip(3)
	.subscribe(onNext: { element in 
		// "D", "E", F"
	}).disposed(by: disposeBag)
```
### skipWhile
Пропускает (отбрасывает) новые элементы пока условие в предикате `skipWhile` равно `false`, как только условие станет `true` - все послудующие элементы будут использоваться далее.
```swift
Observable.of(2, 4, 5, 6, 7, 8)
	.skipWhile { $0 % 2 == 1 }
	.subscribe(onNext: { element in 
		// 5, 6, 7, 8
	}).disposed(by: disposeBag)
```
### skipUntil
Пропускает (отбрасывает) элементы исходной последовательности пока последовательность в тригере не отправит `.onNext`. После этого все значени от исходной будут использоваться.
```swift
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
	.skipUntil(trigger)
	.subscribe(onNext: {
		// print only "B"
	}).disposed(by: disposeBag)
}


subject.onNext("A")
triegger.onNext("X")
subject.onNext("B")
```
##### [Operators](#operators)
## Taking
### take
Берет первых `n` элементов
```swift
Observable.of("A", "B", "C", "D", "E", "F")
	.take(3)
	.subscribe(onNext: {
		// print "A", "B", "C" 
	}).disposed(by: disposeBag)
```
### takeWhile
Берет элементы пока они удовлетворяют условию `takeWhile`. Как только появляется элемент не удовлетворяющий условию, все последжующие перестают проходить дальше.
```swift
Observable.of(1, 2, 3, 4)
        .takeWhile { index in
            return index < 3
        }
        .subscribe(onNext: { item in
            // 1, 2, 3
        }).disposed(by: disposeBag)
```
Можно добавить `enumerated()` для получения не только индекса, но и элемента
```swift
...
Observable.of(1, 2, 3, 4)
	.enumerated()
	.takeWhile { index, item in
	    return item % 2 == 0 && index < 3
	}
	.map { $0.element }
...
```
### takeUntil
Берет элементы исходной последовательности пока последовательность в тригере не отправит `.onNext`. После этого все значени от исходной не будут приниматься.
```swift
let subject = PublishSubject<Int>()
let trigger = PublishSubject<String>()
    
subject
	.takeUntil(trigger)
	.subscribe(onNext: { item in
		// 1, 2
	}).disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)

trigger.onNext("X")
subject.onNext(3)
```
##### [Operators](#operators)
## Distinct
### distinctUntilChanged
Прорускает дальше только отличные от предыдущего значения
```swift
Observable.of(1, 2, 2, 1)
	.distinctUntilChanged()
	.subscribe(onNext: { item in
		// 1, 2, 1
	}).disposed(by: disposeBag)
```
`item` должен быть `Equatable` или можно сделать свое сравнение
```swift
.distinctUntilChanged { a, b in
	a.value == b.value
}
```
##### [Operators](#operators)
## Transforming
### toArray
Собирает все элементы и отдает их массив когда `.onCompleted`
```swift
let subject = BehaviorSubject(value: 1)
subject
	.toArray()
	.subscribe(onNext: { item in
		// [1, 2, 3]
	}).disposed(by: disposeBag)
	
subject.onNext(2)
subject.onNext(3)
subject.onCompleted()
```
### map
Трансформирует каждый элемент
```swift
Observable.of(1, 2, 3)
	.map { "item \($0)" }
	.subscribe(onNext: { item in
		// "item 1", "item 2", "item 3"
	}).disposed(by: disposeBag)
```
### flatMap
Конвертирует элементы одной последовательности в другую последовательность и объединяет наблюдаемую последовательность
```swift
struct Student {
	var score:  BehaviorSubject<Int>
}
   
let s1 = Student(score: BehaviorSubject(value: 80))
let s2 = Student(score: BehaviorSubject(value: 100))

let student = PublishSubject<Student>()

student
	.flatMap { $0.score }
	.subscribe(onNext: {
		// 80, 85, 100, 90, 105
	}).disposed(by: disposeBag)

student.onNext(s1)
s1.score.onNext(85)

student.onNext(s2)

s1.score.onNext(90)
s2.score.onNext(105)
```
### flatMapLatest
В отличии от `flatMap` автоматически переключается на последнюю наблюдаемую последовательность и отписывается от предыдущей
```swift
struct Student {
	var score:  BehaviorSubject<Int>
}

let s1 = Student(score: BehaviorSubject(value: 80))
let s2 = Student(score: BehaviorSubject(value: 100))

let student = PublishSubject<Student>()

student
	.flatMapLatest { $0.score }
	.subscribe(onNext: {
		// 80, 85, 100, 105
	}).disposed(by: disposeBag)

student.onNext(s1)
s1.score.onNext(85)

student.onNext(s2)

s1.score.onNext(90) // not emit
s2.score.onNext(105)
```
### materialize and dematerialize
`materialize` запаковывает испускаемые элементы в event, `dematerialize` распаковывает
```swift
struct Student {
	var score:  BehaviorSubject<Int>
}
    
let student = Student(score: BehaviorSubject(value: 80))
let studentSubject = BehaviorSubject(value: student)

studentSubject
	.flatMapLatest {
		$0.score.materialize()
	}
	.filter {
		guard $0.error == nil else {
			print($0.error!)
			return false
		}
		return true
	}
	.dematerialize()
	.subscribe(onNext: {
		print($0)
	}).disposed(by: disposeBag)

student.score.onNext(85)
student.score.onError(SomeError.anError)
student.score.onNext(90)
```
##### [Operators](#operators)
## Combining
### startWith
Предоставляет начальное значение для последовательности
```swift
let numbers = Observable.of(2, 3, 4).startWith(1)

numbers.subscribe(onNext: { value in
	// 1, 2, 3, 4
}).disposed(by: disposeBag)
```
### concat
`The Observable.concat(_:)` принимает массив последовательностей, подписывается на первую и принимает элементы пока не поступит `onComplete`, далее переходит к следующей. Если какая-либо внутренняя последовательность отправит `onError`, собранная последовательность тоже отправит `onError` и завершится.
```swift
let first = Observable.of(1, 2)
let second = Observable.of(3, 4)

let observable = Observable.concat([first, second])

observable.subscribe(onNext: { value in
	// 1, 2, 3, 4
}).disposed(by: disposeBag)
```
Также `concat` можно применить к экземпляру
```swift
let observable = first.concat(second)
```
### concatMap
Гарантирует, что каждая последовательность, созданная в замыкании `concatMap` будет слушаться до завершения, и только потом подпишется на следующую. Удобный способ для гарантии последовательности выполнения.
```swift
let sequences = [
	"week":  Observable.of("monday", "friday"),
	"month": Observable.of("august", "december")
	]
    
let observable = Observable.of("week", "month")
	.concatMap { country in 
		sequences[country] ?? .empty()
	}

observable.subscribe(onNext: { string in
	// monday, friday, august, december
}).disposed(by: disposeBag)
```
### merge
Подписывается на каждую принимаемую последовательность и выбрасывает новые элементы как только они поступят
```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()
    
let source = Observable.of(left.asObserver(), right.asObserver())
let observable = source
	.merge()
	.subscribe(onNext: { element in
		print(element)
	})
    
right.onNext("right 1")
left.onNext("left 1")
left.onNext("left 2")

observable.dispose()
```
### combineLatest
Подписывается на каждую принимаемую последовательность. Каждый раз, когда внутренняя последовательность выбрасывает значение - получаем последний элемент из каждой внутренней последовательности. Завершается только, когда завершится последняя внутренняя последовательность
```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()
    
let observable = Observable
	.combineLatest(left, right, resultSelector: { lastLeft, lastRight in
		return "\(lastLeft) - \(lastRight)"
	})
	.subscribe(onNext: { nextVal in
		// L2 - R1, L2 - R2, L3 - R2
	})

left.onNext("L1")
left.onNext("L2")
right.onNext("R1")
right.onNext("R2")
left.onNext("L3")
```
### zip
Подписывается на предоставленные последовательности, ожидает пока каждая внутренняя выбросит новое значение и отдает новые значения внутренних посдеовательностей в замыкание. Если хотя бы одна из внутренних последовательностей завершится - завершится и вся последовательность. Для замыкания отдается первый новый элемент внутренней последовательности
```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()
    
let observable = Observable
	.zip(left, right, resultSelector: { e1, e2 in
		return e1 + "-" + e2
	})
	.subscribe(onNext: { nextVal in
		// L1-R1, L2-R2
	})

left.onNext("L1")
left.onNext("L2")
right.onNext("R1")
right.onNext("R2")
left.onNext("L3")
```
##### [Operators](#operators)
## Trigers
### withLatestFrom
Как только в `action` последовательность приходит новый элемент, берет из `input` последовательности последний элемент и испускает дальше его
```swift
let action = PublishSubject<Void>()
let input = PublishSubject<String>()
    
let disposable = action
	.withLatestFrom(input)
	.subscribe(onNext: { text in
		// two, two
	})

input.onNext("one")
input.onNext("two")
action.onNext(())
action.onNext(())
```
### sample
Похож на `withLatestFrom`, но пропускает только новые значение, отличные от отправленных ранее
```swift
let action = PublishSubject<Void>()
let input = PublishSubject<String>()

let disposable = input
	.sample(action)
	.subscribe(onNext: { text in
		// two
	})

input.onNext("one")
input.onNext("two")
action.onNext(())
action.onNext(())
```
##### [Operators](#operators)
## Switches
### amb
Подписывается на две последовательности и ждет пока одна из них получит новый элемент, и отписывается от другого
```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let disposable = left.amb(right)
	.subscribe(onNext: { newItem in
		// L1, L2
	})
    
left.onNext("L1")
right.onNext("R1")
right.onNext("R2")
left.onNext("L2")
```
### switchLatest

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

let observable = source.switchLatest()
let disposable = observable.subscribe(onNext: { newItem in
	// L2, R3
})

left.onNext("L1")
right.onNext("R1")

source.onNext(left)
left.onNext("L2")
right.onNext("R2")

source.onNext(right)
left.onNext("L3")
right.onNext("R3")
```
##### [Operators](#operators)
## Combining within sequence
### reduce
 Аккумулирует элементы исходной последовательности и когда исходная последовательность завершается, испускает результат
```swift
let source = Observable.of(1, 3, 5, 7)
let observable = source.reduce(0, accumulator: { summary, newValue in
	return newValue + summary
})
observable.subscribe(onNext: { item in
	// 16
}).disposed(by: disposeBag)
```
### scan
Аккумулирует элементы, но в отличии от `reduce` не ждет завершения исходной последовательности, а испускает промежуточные результаты сложения
```swift
let source = Observable.of(1, 3, 5, 7)
let observable = source.scan(0, accumulator: { summary, newValue in
	return newValue + summary
})
observable.subscribe(onNext: { item in
	// 1, 4, 9, 16
}).disposed(by: disposeBag)
```
##### [Operators](#operators)
