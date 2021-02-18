//
//  day11.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day11: Day {
	var distance 	= -1
	var maxDistance =  0

	override func getDay() -> Int { return 11 }

	func getDistance(_ x: Int, _ y: Int) -> Int {
		if x >= y {
			return x
		}
		assert((x+y) & 1 == 0)
		return (x + y)/2
	}
	
	func followPath()
	{
		if distance < 0 {
			var x = 0, y = 0
			maxDistance = 0

			for direction in items {
				switch direction {
					case "n":           y -= 2 ; break
					case "ne": x += 1 ; y -= 1 ; break
					case "se": x += 1 ; y += 1 ; break
					case "s":           y += 2 ; break
					case "sw": x -= 1 ; y += 1 ; break
					case "nw": x -= 1 ; y -= 1 ; break
					default: assert(false, "Invalid direction")
				}
				
				maxDistance = max(maxDistance, getDistance(x, y))
			}

			distance = getDistance(x, y)
		}
	}
	
	override func reset()
	{
		distance = -1
		maxDistance  = 0
	}
	
	override func part1() -> String
	{
		followPath()
		return "\(distance)"
	}
	
	override func part2() -> String
	{
		followPath()
		return "\(maxDistance)"
	}
}
