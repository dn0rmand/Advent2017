//
//  day19.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day19: Day {
	override func getDay() -> Int { return 19 }
	
	var steps = 0
	var path  = ""
	
	override func reset() {
		steps = 0
		path  = ""
	}
	
	func process()
	{
		let map = input.map { $0.map { String($0) } }
		
		var y  = 0
		var x  = map[0].firstIndex(of: "|")!
		var dx = 0
		var dy = 1
		
		var visited = [String]()
		var done = false
		
		steps = 0
		
		while !done {
			steps += 1
			x += dx
			y += dy
			
			if x < 0 || y < 0 || y >= map.count || x >= map[0].count {
				break
			}
			
			switch map[y][x] {
				case "|":
					break
				case "-":
					break
					
				case "+":
					if dx == 0 {
						if x > 0 && map[y][x-1] != "." {
							dy = 0
							dx = -1
						} else if x+1 < map[y].count && map[y][x+1] != "." {
							dy = 0
							dx = 1
						} else {
							done = true
						}
					} else {
						if y > 0 && map[y-1][x] != "." {
							dx = 0
							dy = -1
						} else if y+1 < map.count && map[y+1][x] != "." {
							dx = 0
							dy = 1
						} else {
							done = true
						}
					}
					break
				
				case ".":
					done = true
					break
					
				default:
					visited.append(map[y][x])
					break
			}
		}
		
		path = visited.joined()
	}
	
	override func part1() -> String
	{
		if path.count == 0 {
			process()
		}
		
		return path
	}
	
	override func part2() -> String
	{
		if steps == 0 {
			process()
		}
		
		return "\(steps)"
	}
}
