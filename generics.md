### overriding
```swift
class ViewModel {
    var title = ""
}

class SomeView<T: ViewModel>: UIView {
    var viewModel: T?
}


class AnotherViewModel: ViewModel {
    var theme = ""
}

class AnotherView: SomeView<AnotherViewModel> {
    // viewModel now is AnotherViewModel
}
```
### generic
```swift
struct GenericStruct<T> {
    var property: T
}
let someStruct = GenericStruct<Bool>(property: false)
```
### normal protocol
```swift
protocol NormalProtocol {
    var property: String { get set }
}

class NormalClass: NormalProtocol {
   var property: String = "Hi" // must be String
}
```
### protocol associated types
```swift
protocol GenericProtocol {
    associatedtype MyType
    var anyProperty: MyType { get set }
}
```
*define type implicitly*
```swift
class SomeClass: GenericProtocol {
    var anyProperty: String = "Defined now"
}
```
*define type explicitly*
```swift
class SomeClass: GenericProtocol {
    typealias MyType = Int
    var anyProperty: MyType = 1
}
```
*extension*
```swift
extension GenericProtocol where MyType == String, Self == SomeClass {
}
```
