import Foundation

// MARK: - Storage

public class MyStorage {
    
    private var storageStack = [Chip]()
    private let queue = DispatchQueue(label: "storageQueue", qos: .utility, attributes: .concurrent)
    var statusCondition = NSCondition()
    var isWaitingNewChips = true

    var chipsCount: Int {
        return storageStack.count
    }
    var numberOfChipsManufactured = 0
    var numberOfSolderedChips = 0
    
    public init() {}

    func putInStorage(chip: Chip) {
        
        queue.async(flags: .barrier) {
            self.storageStack.append(chip)
        }
    }
    
    func takeFromStorage() -> Chip {
        
        queue.sync {
            return storageStack.removeLast()
        }
    }
}


