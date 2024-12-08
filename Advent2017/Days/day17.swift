//
//  day17.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day17: Day {
	class SpinLockNode {
		var next: SpinLockNode!
		var value: Int
		
		init(value: Int)  {
			self.value = value
			self.next = nil
		}
	}
	
	class SpinLock {
		var count: Int
		var steps: Int
		var zero: SpinLockNode
		var current: SpinLockNode
		
		init(steps: Int)
		{
			current = SpinLockNode(value: 0)
			zero    = current
			current.next = current
			count = 1
			
			self.steps = steps
		}
		
		func Process()
		{
			let newItem = SpinLockNode(value: count)
			let s = steps % count
			
			for _ in 0..<s {
				current = current.next
			}
			
			newItem.next = current.next
			current.next = newItem
			current = newItem
			count += 1
		}
	}
	
	override func getDay() -> Int { return 17 }
	
	override func part1() -> String
	{
		let spinLock = SpinLock(steps: 348)
		
		for _ in 1...2017 {
			spinLock.Process()
		}
		
		return "\(spinLock.current.next.value)"
	}
	
	override func part2() -> String
	{
		let steps    = 348
		var position = 0
		var value    = 0
		var length   = 1
		for i in 1...50000000 {
			position = ((position + steps) % length) + 1
			if position == 1 {
				value = i
			}
			length += 1
		}
		
		return "\(value)"
	}
}
