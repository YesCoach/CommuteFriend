//
//  Task+.swift
//  CommuteFriend
//
//  Created by 박태현 on 11/9/24.
//

protocol CancellableTask {
    func cancel()
}

// rx의 disposeBag 처럼 deinit시 Task를 cancel 시키기 위해 추가
final class TaskCancelBag {

    private var tasks: [any CancellableTask] = []

    func add(task: any CancellableTask) {
        tasks.append(task)
    }

    func cancel() {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()
    }

    deinit {
        cancel()
    }

}

extension Task: CancellableTask {

    func store(in bag: TaskCancelBag) {
        bag.add(task: self)
    }

}
