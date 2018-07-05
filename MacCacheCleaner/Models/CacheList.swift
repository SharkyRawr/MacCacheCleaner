//
//  CacheList.swift
//  MacCacheCleaner
//
//  Created by Kaunteya Suryawanshi on 02/07/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

protocol CacheListDelegate: class {
    func sizeUpdateStarted()
    func gotSizeFor(item: CacheItem)
    func sizeUpdateCompleted()
}

class CacheList {
    // List info loaded from Internet
    var list: [CacheItem]? {
        didSet {
            let qos: DispatchQoS.QoSClass = list == nil ? .default : .utility
            updateSize(queue: DispatchQueue.global(qos: qos))
        }
    }
    private var listWithSizes = [Element]()

    weak var delegate: CacheListDelegate?
}

extension CacheList {

    func updateSize(queue: DispatchQueue) {
        delegate?.sizeUpdateStarted()
        let dispatchGroup = DispatchGroup()
        list?.forEach { item in
            queue.async {
                dispatchGroup.enter()
                let size = item.files.calculateSize()
                DispatchQueue.main.async { [unowned self] in
                    dispatchGroup.leave()
                    if size.bytes > 0 {
                        self.updateListWithSizes(element: Element(id: item.id, size: size))
                        self.delegate?.gotSizeFor(item: item)
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.delegate?.sizeUpdateCompleted()
        }
    }

    subscript(id: CacheID) -> CacheItem? {
        let item = list?.first(where: { $0.id == id })
        return item
    }

    private func updateListWithSizes(element: Element) {
        for (index, iElement) in listWithSizes.enumerated() where iElement.id == element.id {
            listWithSizes[index] = element
            return
        }
        listWithSizes.append(element)
    }
}

extension CacheList: Collection {
    subscript(position: Int) -> (id: CacheID, size: CacheSize) {
        return listWithSizes[position]
    }

    typealias Index = Int
    typealias Element = (id: CacheID, size: CacheSize)

    func index(after i: Int) -> Int {
        return listWithSizes.index(after: i)
    }

    var startIndex: CacheList.Index {
        return listWithSizes.startIndex
    }
    var endIndex: CacheList.Index {
        return listWithSizes.endIndex
    }
}
