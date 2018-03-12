[/]:# (https://gist.github.com/MinhasKamal/7fdebb7c424d23149140#file-github-markdown-syntax-md)

[/]:# (stackedit.io)

## Operators
### Filterting 
* [Ignoring](#ignoring)
	* [ignoreElements](#ignoreelements)
	* [elementAt](#elementat)
	* [filter](#filter)
* [Skipping](#skipping)
	* [skip](#skip)
	* [skipWhile](#skipwhile)
	* [skipUntil](#skipuntil)
* [Taking](#taking)
	* [take](#take)
	* [takeWhile](#takewhile)
	* [takeUntil](#takeuntil)
* [Distinct](#distinct)
	* [distinctUntilChanged](#distinctuntilchanged)
### Transforming
* [toArray](#toarray)
* [map](#map)
* [flatMap](#flatmap)
* [flatMapLatest](#flatmaplatest)
* [materialize](#materialize)
* [materialize & dematerialize](#materializeanddematerialize)
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
