## Errors handling
* [catchErrorJustReturn](#catcherrorjustreturn)
* [catchError](#catcherror)
* [retry](#retry)
* [retryWhen](#retrywhen)
---
Тестовая функция, возвращающая ошибку:
```swift
enum NetworkError: Error {
    case notReachable
    case unknown
}


func testMethod(_ wrappedError: Error) -> Observable<String> {
    return Observable.error(wrappedError)
}
```
### catchErrorJustReturn
Предоставляет значение, если приходит событие с ошибкой
```swift
testMethod(NetworkError.notReachable)
    .catchErrorJustReturn("placeholder")
    .subscribe(onNext: { string in
        // placeholder
    }).disposed(by: bag)
```
### catchError
Может обработать ошибку и вернуть `Observable` с тем же типом или бросить ее дальше
```swift
testMethod(NetworkError.notReachable)
    .catchError { error in
        if case NetworkError.notReachable = error {
            return Observable.just("handled error: no network")
        }
        throw error
    }
    .subscribe(onNext: { string in
        // no network
    }).disposed(by: bag)
```
### retry
Два варианта `retry()` и `retry(maxAttemptCount: Int)`, где `maxAttemptCount` кол-во повторов
### retryWhen
```swift
func testMethod2(_ wrappedError: Error) -> Observable<Int> {
    return Observable.error(wrappedError)
}
        
let maxAttempts = 3
        
let retryHandler: (Observable<Error>) -> Observable<Int> = { e in
    return e.enumerated().flatMap { attempt, error -> Observable<Int> in
        if attempt >= maxAttempts - 1 {
            return Observable.error(error)
        }
        print("wait \(attempt + 1)...")
        return Observable<Int>.timer(Double(attempt + 1), scheduler: MainScheduler.instance).take(1)
    }
}
        
testMethod2(NetworkError.notReachable)
    .retryWhen(retryHandler)
    .subscribe(onNext: { string in
        print(string)
    }).disposed(by: disposeBag)
```
