//
//  day5.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day5: Day {
	override func getDay() -> Int { return 5 }
	
	func loadProgram() -> [Int] {
		var program = [Int]()
		
		for line in input {
			program.append(Int(line)!)
		}
		
		return program
	}
	
	override func part1() -> String
	{
		var program = loadProgram()
		var ip = program.index(program.startIndex, offsetBy: 0)
		var steps = 0
		while ip >= program.startIndex && ip < program.endIndex {
			let jump = program[ip]
			program[ip] += 1
			ip = ip.advanced(by: jump)
			steps += 1
		}
		
		return "\(steps)"
	}
	
	override func part2() -> String
	{
		var program = loadProgram()
		var ip = program.index(program.startIndex, offsetBy: 0)
		var steps = 0
		while ip >= program.startIndex && ip < program.endIndex {
			let jump = program[ip]
			if jump < 3 {
				program[ip] += 1
			} else {
				program[ip] -= 1
			}
			ip = ip.advanced(by: jump)
			steps += 1
		}
		
		return "\(steps)"
	}
}
