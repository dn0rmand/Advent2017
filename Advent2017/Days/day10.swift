//
//  day10.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day10: Day {
	let hexCharacters = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
	
	class Knot {
		var skip = 0
		var current = 0
		var data = Array(0..<256)
		var sequences: [Int]
		
		init(_ sequences: [Int]) {
			self.sequences = sequences
		}
		
		func hash() {
			for sequence in sequences {
				let start = current
				let seq   = sequence / 2
				
				for i in 0..<seq {
					let s = (start + i) % 256
					let e = (start + sequence - i - 1 + 256) % 256
					let tmp = data[s]
					data[s] = data[e]
					data[e] = tmp
				}
				
				current = (current + sequence + skip) % 256
				skip = (skip + 1) % 256
			}
		}
	}
	
	override func getDay() -> Int { return 10 }
	
	func getSequences() -> [Int] {
		let data = items.map { Int(String($0))! }
		return data
	}

	func getSequences2() -> [Int] {
		let line = input[0]
		var data = line.map { Int($0.asciiValue!) }
		data.append(contentsOf: [17, 31, 73, 47, 23])
		return data
	}

	override func part1() -> String
	{
		let context = Knot(getSequences())
		
		context.hash()
		let answer = context.data[0] * context.data[1]
		
		return "\(answer)"
	}
	
	override func part2() -> String
	{
		let context = Knot(getSequences2())
		
		for _ in 1...64 { context.hash() }
		
		var result = ""
		
		for i in  0..<16 {
			let value = context.data[i*16..<(i+1)*16].reduce(0) { $0 ^ $1 }
			result = String.init(format: "%@%02x", result, value)
		}
				
		return "\(result)"
	}
}
