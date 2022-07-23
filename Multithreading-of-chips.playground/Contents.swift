import Foundation

let storage = MyStorage()

let generatingThread = GeneratingThread(storage: storage)
generatingThread.start()

let workThread = WorkThread(storage: storage)
workThread.start()
