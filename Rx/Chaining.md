## Chaining
Поможет `flatMap`. Есть, например, два Observable
```swift
func observableString() -> Observable<String> {
	return Observable.create { observable -> Disposable in
  		observable.onNext("12")
    		observable.onCompleted()
        	return Disposables.create()
	}
}
```
```swift
func observableInt(string: String) -> Observable<Int> {
	return Observable.create { observable -> Disposable in
		observable.onNext(Int(string)!)
		observable.onCompleted()
		return Disposables.create()
	}
}
```
В итоге 
```swift
observableString()
	.flatMap { string -> Observable<Int> in
		return observableInt(string: string)
	}.subscribe(onNext: { intVal in
		print("val:", intVal)
	}).disposed(by: disposeBag)
```
