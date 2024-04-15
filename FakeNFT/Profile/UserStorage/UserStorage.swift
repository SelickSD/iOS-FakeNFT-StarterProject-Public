import Foundation

struct SortingMethod {
    enum Method: String {
        case sortByPrice = "Sort by price"
        case sortByRating = "Sort by rating"
        case sortByName = "Sort by name"
    }

    static var sortMethod: Method {
        get {
            guard let method = UserDefaults.standard.string(forKey: "sorting_method") else {
                return .sortByPrice
            }
            return Method(rawValue: method) ?? .sortByName
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "sorting_method")
        }
    }
}
