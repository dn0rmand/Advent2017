//
//  day1.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day1: Day {
	override func getDay() -> Int { return 1 }
	
	override func part1() -> String
	{
		let line = input[0]
		var total: Int = 0
		for index in 0..<line.count {
			let i0 = line.index(line.startIndex, offsetBy: index)
			let i1 = line.index(line.startIndex, offsetBy: (index+1) % line.count)
			
			if line[i0] == line[i1] {
				let digit = line[i0]
				total = total + digit.wholeNumberValue!
			}
		}
		
		return "\(total)"
	}
	
	override func part2() -> String
	{
		let line = input[0]
		var total: Int = 0
		let count = line.count / 2
		
		for index in 0..<count {
			let i0 = line.index(line.startIndex, offsetBy: index)
			let i1 = line.index(line.startIndex, offsetBy: index+count)
			
			if line[i0] == line[i1] {
				let digit = line[i0]
				total = total + digit.wholeNumberValue!
			}
		}
		
		return "\(2*total)"
	}
}
