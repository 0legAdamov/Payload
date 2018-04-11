## Errors handling
* [catchErrorJustReturn](#catcherrorjustreturn)
* [catchError](#catcherror)
* [retry](#retry)
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
