import Foundation

// MARK: - GeneratingThread

public class GeneratingThread: Thread {
    
    private var storage = MyStorage()
    var timer = Timer()
    
    public init(storage: MyStorage) {
        self.storage = storage
    }
    
    public override func main() {
        
        timer = Timer.scheduledTimer(timeInterval: 2,
                                     target: self,
                                     selector: #selector(startGenerationOperation),
                                     userInfo: nil,
                                     repeats: true)
        
        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run(until: .now + 20)
        storage.isWaitingNewChips = false
    }

    @objc func startGenerationOperation() {
        
        let myChip = Chip.make()
        storage.putInStorage(chip: myChip)
        chipsLog(chip: myChip)
        workThreadCommand()
        storage.numberOfChipsManufactured += 1
    }
    
    func workThreadCommand() {
        
        guard storage.chipsCount > 0 else { return }
        storage.statusCondition.signal()
    }
}

extension GeneratingThread {
    
    func chipsLog(chip: Chip) {
        print("""
        Чип успешно изготовлен!
        Тип чипа:\(chip.chipType)
        Серийный номер чипа: \(chip.chipSerialNum)
        Количество на складе:\(storage.chipsCount)
        """)
    }
}
