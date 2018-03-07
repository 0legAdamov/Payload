[/]:# (https://gist.github.com/MinhasKamal/7fdebb7c424d23149140#file-github-markdown-syntax-md)

[/]:# (stackedit.io)

 ### Operators
*  [Filtering](#filtering)
	*  ignoreElements
***
### Filtering
**ignoreElements**

Игнорирует `.next`  и пропускает только `.completed` и 
`.error`
```swift
let subject = PublishSubject<String>()
let disposeBag = DisposeBag()

subject.ignoreElements().subscribe { _ in 
	// print on .completed or .error
}
```
##### [Operators](#operators)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzNTQ5MDQ4MDFdfQ==
-->