//
//  day13.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day13: Day {
	override func getDay() -> Int { return 13 }
	
	func getLayers() -> [Int]
	{
		var layers = [Int]()
		
		for line in input {
			let parser = Parser(input: line)
			let depth  = parser.getNumber()
			parser.expect(chars: ":")
			let range = parser.getNumber()
			
			while layers.count < depth { layers.append(0) }
			
			layers.append(range)
		}
		
		return layers
	}
	
	override func part1() -> String
	{
		let layers = getLayers()
		
		var score = 0
		
		for layer in 0..<layers.count {
			if layers[layer] > 0 {
				let mod = layers[layer]*2 - 2
				let pos = layer % mod
				if pos == 0 {
					// caught!
					score += layer * layers[layer]
				}
			}
		}
		
		return "\(score)"
	}
	
	override func part2() -> String
	{
		let layers = getLayers()
		
		var start = 0
		var caught = true
		while caught {
			start += 1
			caught = false
			for layer in 0..<layers.count {
				let time = layer+start
				if layers[layer] > 0 {
					let mod = layers[layer]*2 - 2
					let pos = time % mod
					if pos == 0 {
						caught = true
						break
					}
				}
			}
		}
		
		return "\(start)"
	}
}
