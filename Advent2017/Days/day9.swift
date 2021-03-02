//
//  day9.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day9: Day {
	override func getDay() -> Int { return 9 }
	
	var garbageSize = 0;
	
	func ignoreGarbage(input: String, index: String.Index) -> String.Index
	{
		Assert(input[index] == "<")
		var pos = input.index(index, offsetBy: 1)
		while input[pos] != ">" {
			if input[pos] == "!" {
				pos = input.index(pos, offsetBy: 2)
			} else {
				garbageSize += 1
				pos = input.index(pos, offsetBy: 1)
			}
		}
		
		pos = input.index(pos, offsetBy: 1)
		return pos
	}
	
	func getGroupScore(data: String, index: String.Index, value: Int) -> (String.Index, Int)
	{
		Assert(data[index] == "{")
		var pos = data.index(index, offsetBy: 1)
		
		var score = value
		var c = data[pos]

		while c != "}" {
			if c == "{" {
				let (newPos, subScore) = getGroupScore(data: data, index: pos, value: value+1)
				score += subScore
				pos = newPos
			} else if c == "<" {
				pos = ignoreGarbage(input: data, index: pos)
			} else if c == "," {
				pos = data.index(pos, offsetBy: 1)
			} else {
				Assert(false, "Invalid data")
			}
			
			c = data[pos]
		}
		
		pos = data.index(pos, offsetBy: 1)
		return (pos, score)
	}
	
	override func reset() {
		garbageSize = 0
	}
	
	override func part1() -> String
	{
		let data = input[0]
		let (_, score) = self.getGroupScore(data: data, index: data.startIndex, value: 1)
		return "\(score)"
	}
	
	override func part2() -> String
	{
		if garbageSize == 0 {
			_ = part1()
		}
		return "\(garbageSize)"
	}
}
