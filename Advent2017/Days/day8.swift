//
//  day8.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day8: Day {
	override func getDay() -> Int { return 8 }
	
	var registers = [String:Int]()
	var maximum   = 0
	
	override func reset()
	{
		registers = [String:Int]()
		maximum   = 0
	}
	
	func getValue(register: String) -> Int
	{
		let v = registers[register]
		if v == nil {
			return 0
		} else {
			return v!
		}
	}

	func setValue(register: String, value: Int)
	{
		if value > maximum { maximum = value }
		registers[register] = value
	}

	func evaluateCondition(parser: Parser) -> Bool {
		assert(parser.getToken() == "if")
		let register = parser.getToken()
		let op = parser.getOperator()
		let value = parser.getNumber()
		
		let v = getValue(register: register)
		
		switch op {
			case "==": return v == value
			case "!=": return v != value
			case ">":  return v > value
			case ">=": return v >= value
			case "<":  return v < value
			case "<=": return v <= value
			default:
				assert(false, "Invalid operator \(op)")
		}
		
		return false
	}
	
	func process(part: Int) -> Int
	{
		if registers.count == 0 {
			// not executed yet
			
			for line in input {
				let parser = Parser(input: line)
				
				let target  = parser.getToken()
				let command = parser.getToken()
				let value   = parser.getNumber()
				
				if evaluateCondition(parser: parser) {
					var r = getValue(register: target)
					
					if command == "dec" {
						r -= value
					} else if command == "inc" {
						r += value
					}
					else {
						assert(command == "inc" )
					}
					
					setValue(register: target, value: r)
				}
			}
		}
		
		if part == 1 {
			let m = registers.max { a, b in a.value < b.value }
			return m!.value
		} else {
			return maximum
		}
	}
	
	override func part1() -> String
	{
		let result = process(part:1)
		return "\(result)"
	}
	
	override func part2() -> String
	{
		let result = process(part:2)
		return "\(result)"
	}
}
