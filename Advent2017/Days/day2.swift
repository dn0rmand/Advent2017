//
//  day2.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day2: Day {
	override func getDay() -> Int { return 2 }
	
	private var _values : [[Int]]? = nil
	
	var values : [[Int]] {
		get {
			if (_values == nil) {
				var vals = [[Int]]()
				
				for line in input {
					var row = [Int]()
					
					for num in line.split(separator: "\t") {
						row.append(Int(num)!)
					}
					
					row.sort()
					vals.append(row)
				}
				
				_values = vals
			}
			return _values!
		}
	}
	
	override func part1() -> String
	{
		var total = 0
		
		for row in values {
			let min = row[row.startIndex]
			let max = row[row.index(before: row.endIndex)]
			total += max-min
		}
		
		return "\(total)"
	}
	
	override func part2() -> String
	{
		var total = 0
		
		for row in values {
			var found = false
			for i in 1...row.count {
				let max = row[row.index(row.startIndex, offsetBy: row.count-i)]
				for min in row {
					if min >= max {
						break
					}
					if max % min == 0 {
						total += max/min
						found = true
						break
					}
				}
				if found { break }
			}
		}
		
		return "\(total)"
	}
}
