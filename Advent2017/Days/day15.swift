//
//  day15.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day15: Day {
	
	class Generator {
		var previous: Int
		let factor: Int
		
		init(_ value: Int, factor:  Int) {
			previous = value
			self.factor = factor
		}
		
		func next() -> Int {
			previous = (previous * factor) % 2147483647
			return previous & 0xFFFF
		}
		
		func next2(mask: Int) -> Int {
			var count = 1
			previous = (previous * factor) % 2147483647
			while (previous & mask) != 0 {
				previous = (previous * factor) % 2147483647
				count += 1
			}
			
			return previous & 0xFFFF
		}
	}
	
	override func getDay() -> Int { return 15 }
	
	override func part1() -> String
	{
		let A = Generator(722, factor:16807)
		let B = Generator(354, factor:48271)
		
		var score = 0
		
		for _ in 1...40000000 {
			let a = A.next()
			let b = B.next()

			if a == b {
				score += 1
			}
		}
		
		return "\(score)"
	}
	
	override func part2() -> String
	{
		let A = Generator(722, factor:16807)
		let B = Generator(354, factor:48271)
		
		var score = 0
		
		for _ in 1...5000000 {
			let a = A.next2(mask: 3)
			let b = B.next2(mask: 7)
			
			if a == b { score += 1 }
		}
		
		return "\(score)"
	}
}
