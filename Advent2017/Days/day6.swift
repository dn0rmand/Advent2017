//
//  day6.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day6: Day {
	override func getDay() -> Int { return 6 }
	
	func loadMemory() -> [Int] {
		var memory = [Int]()
		for n in input[0].split(separator: "\t") {
			memory.append(Int(n)!)
		}
		return memory
	}
	
	func makeKey(memory: [Int]) -> String {
		var mem: [UInt8] = memory.map { UInt8($0+10) }
		mem.append(0)
		return String.init(cString: mem)
	}
	
	var _steps: Int? = nil
	var _frequency: Int? = nil
	
	func calculate()
	{
		if _steps != nil { return }
		
		var memory  = loadMemory()
		var visited = [String:Int]()		
		var steps   = 0
		
		while true {
			let key = makeKey(memory: memory)
			
			if visited.keys.contains(key) {
				_steps = steps
				_frequency = steps - visited[key]!
				break
			}
			
			visited[key] = steps
			
			let max = memory.max()!
			var maxIndex = memory.firstIndex { $0 == max }!
			var rest  = max % memory.count
			let toAll = (max - rest) / memory.count
			
			memory[maxIndex] = 0

			if toAll > 0 {
				for (n, v) in memory.enumerated() {
					memory[n] = v + toAll
				}
			}
			while rest > 0 {
				maxIndex = maxIndex.advanced(by: 1) % memory.count
				memory[maxIndex] += 1
				rest -= 1
			}
			steps += 1
		}
	}
	
	override func reset()
	{
		_steps = nil
		_frequency = nil
	}
	
	override func part1() -> String
	{
		calculate()
		return "\(_steps!)"
	}
	
	override func part2() -> String
	{
		calculate()
		return "\(_frequency!)"
	}
}
