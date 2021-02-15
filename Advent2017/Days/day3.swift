//
//  day3.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day3: Day {
	override func getDay() -> Int { return 3 }
	
	var inputValue: Int {
		get {
			return Int(input[0])!
		}
	}
	
	override func part1() -> String
	{
		let target 	  = inputValue
		var max  	  = 1
		var ring      = 0
		var ringSize  = 0
		var ringWidth = 1
		
		while max < target {
			ring      += 1
			ringWidth += 2
			ringSize  += 8
			max       += ringSize
		}
		
		while max-ringWidth+1 > target {
			max -= ringWidth-1
		}
		let middle = max - (ringWidth-1)/2
		let steps  = abs(middle-target)+ring
		return "\(steps)"
	}
	
	var _spiral = [String: Int]()

	func getSpiralValue(x: Int, y: Int) -> Int {
		let key = "\(x):\(y)"
		let v = _spiral[key]
		if v == nil { return 0} else { return v! }
	}

	func setSpiralValue(x: Int, y: Int, value: Int) {
		let key = "\(x):\(y)"
		_spiral[key] = value
	}
	
	func calculate(x: Int, y: Int) -> Int {
		let v = getSpiralValue(x: x-1, y: y-1) + getSpiralValue(x: x, y: y-1) + getSpiralValue(x: x+1, y: y-1) +
				getSpiralValue(x: x-1, y: y)   +                                getSpiralValue(x: x+1, y: y) +
				getSpiralValue(x: x-1, y: y+1) + getSpiralValue(x: x, y: y+1) + getSpiralValue(x: x+1, y: y+1)
		setSpiralValue(x: x, y: y, value: v)
		return v
	}
	
	override func part2() -> String
	{
		let target = inputValue
		
		// reset :)
		_spiral.removeAll()
		setSpiralValue(x: 0, y: 0, value: 1)
		
		var minX = -1, maxX = 1, minY = -1, maxY = 1
		
		while true {
			for y in (minY...maxY-1).reversed() {
				let v = calculate(x: maxX, y: y)
				if v >= target { return "\(v)" }
			}
			for x in (minX...maxX-1).reversed() {
				let v = calculate(x: x, y: minY)
				if v >= target { return "\(v)" }
			}
			for y in (minY+1...maxY) {
				let v = calculate(x: minX, y: y)
				if v >= target { return "\(v)" }
			}
			for x in (minX+1...maxX) {
				let v = calculate(x: x, y: maxY)
				if v >= target { return "\(v)" }
			}
			
			maxX += 1
			maxY += 1
			minX -= 1
			minY -= 1
		}
	}
}
