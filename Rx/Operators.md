[/]:# (https://gist.github.com/MinhasKamal/7fdebb7c424d23149140#file-github-markdown-syntax-md)

[/]:# (stackedit.io)

 ### Operators
*  [Filtering](#filtering)
	*  ignoreElements
	* elementAt
	* filter
* [Skipping](#skipping)
***
## Filtering
### ignoreElements

Игнорирует `.next`  и пропускает только `.completed` и 
`.error`
```swift
let subject = PublishSubject<String>()
subject.ignoreElements().subscribe { _ in 
	// print on .completed or .error
}.disposed(by: disposeBag)
```
### elementAt(_:)
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
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwODIwOTMxNDNdfQ==
-->