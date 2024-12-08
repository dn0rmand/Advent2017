//
//  day14.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day14: Day {
	override func getDay() -> Int { return 14 }

	class Grid {
		private var data: [[Int]]
		private var bits: Int
		
		init(_ prefix: String) {
			data = [[Int]]()
			bits = 0
			
			for i in 0..<128 {
				let row = KnotHash("\(prefix)-\(i)").hash(64).toRaw()
				var r = Array(repeating: 0, count: 128)
				var x = 0
				for o in row {
					var mask: UInt8 = 0x80
					while mask > 0 {
						if Int(o & mask) != 0 {
							bits += 1
							r[x] = 1
						}
						mask >>= 1
						x += 1
					}
				}
				data.append(r)
			}
		}
		
		func clearGroup(_ x: Int, _ y: Int) {
			if data[y][x] == 1 {
				data[y][x] = 0
				if x+1 < 128 { clearGroup(x+1, y) }
				if x > 0 	 { clearGroup(x-1, y) }
				if y+1 < 128 { clearGroup(x, y+1) }
				if y > 0 	 { clearGroup(x, y-1) }
			}
		}
		
		func countBits() -> Int {
			return bits
		}
		
		func countRegions() -> Int {
			var regions = 0
			
			for y in 0..<128 {
				for x in 0..<128 {
					if data[y][x] == 1 {
						regions += 1
						clearGroup(x, y)
					}
				}
			}
			
			return regions
		}
	}
		
	private var _grid: Grid? = nil
	
	var grid : Grid {
		get {
			if (_grid == nil) {
				_grid = Grid(input[0])
			}
			return _grid!
		}
	}
	
	override func reset()
	{
		_grid = nil
	}
	
	override func part1() -> String
	{
		let bits = grid.countBits()
		return "\(bits)"
	}
	
	override func part2() -> String
	{
		let regions = grid.countRegions()
		return "\(regions)"
	}
}
