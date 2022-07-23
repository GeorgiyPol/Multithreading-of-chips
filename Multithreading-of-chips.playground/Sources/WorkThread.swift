import Foundation

// MARK: - WorkThread

public class WorkThread: Thread {
    
    private var storage = MyStorage()
    
    public init(storage: MyStorage) {
        self.storage = storage
    }
    
    public override func main() {
        if storage.isWaitingNewChips {
            storage.statusCondition.lock()
            
            while storage.chipsCount <= 0 {
                storage.statusCondition.wait()
                print(EventDescription.waitingForTheChip.rawValue)
            }
            
            while storage.chipsCount > 0 {
                print(EventDescription.takeFromStorage.rawValue)
                storage.takeFromStorage().sodering()
                storage.numberOfSolderedChips += 1

            }
            
            storage.statusCondition.unlock()
            
            main()
        } else {
            print(EventDescription.completionOfWork.rawValue)
            countingResults(storage: storage)
        }
        
    }
}

extension WorkThread {
    enum EventDescription: String {
        case waitingForTheChip = "\nОжидание изготовления чипа"
        case takeFromStorage = "\nЧип забран из хранилища. Проведение пайки.\n"
        case completionOfWork = "\nРабота завершена."
    }
    
    func countingResults(storage: MyStorage) {
        print("Изготовлено чипов: \(storage.numberOfChipsManufactured)")
        print("Количество пропаянных чипов: \(storage.numberOfSolderedChips)")
    }
}

