//
//  day22.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day22: Day {
	enum NodeState {
		case clean, weakened, infected, flagged
	}
	
	static func makeKey(_ x: Int, _ y: Int ) -> Int
	{
		let xx = (x + 999)
		let yy = (y + 999)
		return (xx * 10000) + yy
	}
	
	class Virus {
		var x: Int = 0
		var y: Int = 0
		var dx: Int = 0
		var dy: Int = -1
		var infections: Int = 0
		var map: [Int: NodeState]
		
		init(map: [Int: NodeState])
		{
			self.map = map
		}
		
		var key: Int { get { return Day22.makeKey(x, y) } }
		
		func get() -> NodeState
		{
			if let current = map[key] {
				return current
			}  else {
				return .clean
			}
		}
		
		func set(_ state: NodeState)
		{
			map[key] = state
			if state == .infected {
				infections += 1
			}
		}

		func burst1()
		{
			if get() == .infected {
				// turn right
				(dx, dy) = (-dy, dx)
				set(.clean)
			} else {
				// turn left
				(dx, dy) = (dy, -dx)
				set(.infected)
			}
			x += dx
			y += dy
		}
		
		func burst2()
		{
			switch get() {
				case .clean:
					(dx, dy) = (dy, -dx)
					set(.weakened)
					break
				case .infected:
					(dx, dy) = (-dy, dx)
					set(.flagged)
					break
				case .flagged:
					(dx, dy) = (-dx, -dy)
					set(.clean)
					break
				case .weakened:
					set(.infected)
					break
			}
			
			x += dx
			y += dy
		}
	}
	
	override func getDay() -> Int { return 22 }
	
	func loadMap() -> [Int:NodeState] {
		let maxX = input[0].count
		let maxY = input.count
		
		var map = [Int: NodeState]()
		var y = -(maxY >> 1)
		for line in input {
			var x = -(maxX >> 1)
			for c in line {
				if c == "#" {
					let key = Day22.makeKey(x, y)
					map[key] = .infected
				}
				x += 1
			}
			y += 1
		}
		
		return map
	}
	
	override func part1() -> String
	{
		let virus = Virus(map: loadMap())
		for _ in 1...10000 {
			virus.burst1()
		}
		
		return "\(virus.infections)"
	}
	
	override func part2() -> String
	{
		let virus = Virus(map: loadMap())
		for _ in 1...10000000 {
			virus.burst2()
		}
		
		return "\(virus.infections)"
	}
}
