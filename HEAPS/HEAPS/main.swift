//
//  main.swift
//  HEAPS
//
//  Created by Alex P on 07/06/2019.
//  Copyright © 2019 Alex Perov. All rights reserved.
//

import Foundation

// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

struct Heap<Element: Equatable> {
    
    var elements: [Element] = []
    var sort: (Element, Element) -> Bool
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements
        
        if !elements.isEmpty {
            for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i, upTo: elements.count)
            }
        }
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var isFull: Bool {
        return !elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    func peek() -> Element? {
        return elements.first
    }
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        return (2 * index) + 1
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        return (2 * index) + 2
    }
    
    func parentIndex(ofChildAt index: Int) -> Int {
        return (index - 1) / 2
    }
    
    mutating func remove() -> Element? {
        guard !isEmpty else {
            return nil
        }
        elements.swapAt(0, count - 1)
        defer {
            siftDown(from: 0, upTo: elements.count)
        }
        return elements.removeLast()
    }
    
    mutating func siftDown(from index: Int, upTo size: Int) {
        var parent = index
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candidate = parent
            if left < size && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < size && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
    
    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }
    
    mutating func siftUp(from index: Int) {
        var child = index
        var parent = parentIndex(ofChildAt: child)
        while child > 0 && sort(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(ofChildAt: child)
        }
    }
    
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else {
            return nil // 1
        }
        if index == elements.count - 1 {
            return elements.removeLast() // 2
        } else {
            elements.swapAt(index, elements.count - 1) // 3
            defer {
                siftDown(from: index, upTo: elements.count) // 5
                siftUp(from: index)
            }
            return elements.removeLast() // 4
        }
    }
    
    func index(of element: Element, startingAt i: Int) -> Int? {
        if i >= count {
            return nil
        }
        if sort(element, elements[i]) {
            return nil
        }
        if element == elements[i] {
            return i
        }
        if let j = index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
            return j
        }
        if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
            return j
        }
        return nil
    }
}

extension Heap {
    
    func sorted() -> [Element] {
        var heap = Heap(sort: sort, elements: elements)
        for index in heap.elements.indices.reversed() {
            heap.elements.swapAt(0, index)
            heap.siftDown(from: 0, upTo: index)
        }
        return heap.elements
    }
    func changePriorityToMin() {
        heap.sort = {$0 < $1}
        for index in heap.elements.indices.reversed() {
            heap.siftDown(from: index, upTo: elements.count)
        }
    }
    func changePriorityToMax() {
        heap.sort = {$0 > $1}
        for index in heap.elements.indices.reversed() {
            heap.siftDown(from: index, upTo: elements.count)
        }
    }
}

var heap = Heap(sort: >, elements: [6, 12, 2, 26, 8, 18, 21, 9, 5])
//print(heap.isFull)
//print(heap.isEmpty)
//print(heap.count)
//print(heap.elements)
//heap.changePriorityToMin()
//print(heap.elements)
//print(heap.sorted())
//heap.changePriorityToMax()
//print(heap.elements)
//print(heap.sorted())
//heap.remove(at: 0)
//print(heap.sorted())

while true {
    var heapArr = [Int]()
    print("Insert number of elements")
    var sizeInput = readLine()
    guard let sizeStr = sizeInput else { continue }
    guard let size = Int(sizeStr) else { continue }
    print("insert elements")
    for _ in 1...size {
        let item = readLine()
        if let pitem = item, let iitem = Int(pitem) {
            heapArr.append(iitem)
        }
    }
    print("heap elements unsorted: \(heapArr)")
    var heap1 = Heap(sort: >, elements: heapArr)
    print("heap elements sorted as heap: \(heap1.elements)")
    print("heap elements after heapsort: \(heap1.sorted())")
    print("heap is full: \(heap1.isFull)")
    print("number of elements: \(heap1.count)")
    print("removing root element")
    heap1.remove(at: 0)
    print("Heap elements after removing root: \(heap1.elements)")
    print("changing max heap to min heap")
    heap1.sort = {$0 < $1}
    for index in heap1.elements.indices.reversed() {
        heap1.siftDown(from: index, upTo: heap1.elements.count)
    }
    print("unsorted elements: \(heap1.elements)")
    print("sorted elements: \(heap1.sorted())")
}
