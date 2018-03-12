## Chaining
Поможет `flatMap`. Есть, например, два Observable
```swift
let disposeBag = DisposeBag()
    
func observableString() -> Observable<String> {
	return Observable.create { observable -> Disposable in
    	observable.onNext("12")
    	observable.onCompleted()
        	return Disposables.create()
		}
}

func observableInt(string: String) -> Observable<Int> {
	return Observable.create { observable -> Disposable in
		observable.onNext(Int(string)!)
		observable.onCompleted()
		return Disposables.create()
	}
}
```
