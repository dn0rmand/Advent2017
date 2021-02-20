//
//  day10.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day10: Day {
	override func getDay() -> Int { return 10 }
	
	func getSequences() -> [Int] {
		let data = items.map { Int(String($0))! }
		return data
	}

//	func getSequences2() -> [Int] {
//		let line = input[0]
//		var data = line.map { Int($0.asciiValue!) }
//		data.append(contentsOf: [17, 31, 73, 47, 23])
//		return data
//	}

	override func part1() -> String
	{
		let data = KnotHash(getSequences()).hash(1).data
		let answer = data[0] * data[1]		
		return "\(answer)"
	}
	
	override func part2() -> String
	{
		return KnotHash(input[0]).hash(64).toHEX()
	}
}
