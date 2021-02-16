//
//  day7.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day7: Day {
	
	class Program {
		let name: String
		let weight: Int
		var children: [Program]
		var parent: Program? = nil
		
		lazy var totalWeight: Int = {
			let w = children.reduce(weight) { $0 + $1.totalWeight }
			return w
		}()
		
		lazy var isBalanced: Bool = {
			if children.count < 2 {
				return true
			}
			let expected = children.first!.totalWeight
			let unbalanced = children.first { $0.totalWeight != expected }
			return unbalanced == nil
		}()
		
		init(name: String, weight: Int, children: [Program])
		{
			self.name = name
			self.weight = weight
			self.children = children
		}
	}
	
	override func getDay() -> Int { return 7 }
	
	func load() -> [String:Program] {
		var programs = [String:Program]()
		
		for line in input {
			var children = [Program]()
			let entries = line.split(separator: "-")
			if entries.count > 1 {
				children = entries[1]
								.dropFirst()
								.split(separator: ",")
								.map {
									let name = String($0.trimmingCharacters(in: CharacterSet.whitespaces))
									var p = programs[name]
									if p == nil {
										// use place holder
										p = Program(name:name, weight: 0, children: [Program]())
									}
									return p!
								}
			}
			
			let entries2 = entries[0].split(separator: "(")
			let name 	 = String(entries2[0].trimmingCharacters(in: CharacterSet.whitespaces))
			let weight 	 = Int(String(entries2[1].split(separator: ")")[0]))!
			
			let p = Program(name: name, weight: weight, children: children)
			programs[name] = p
		}
		
		for (_, program) in programs {
			// replace place holders
			program.children = program.children.map { programs[$0.name]! }
			// assign parent ( this helps finding the root )
			for child in program.children {
				programs[child.name]?.parent = program
			}
		}
		
		return programs
	}
	
	override func part1() -> String
	{
		let programs = load()
		let root = programs.first { $0.value.parent == nil }
		return root!.value.name
	}
	
	override func part2() -> String
	{
		var result: Int = 0
		
		let programs = load()
		var program  =  programs.first { $0.value.parent == nil }!.value
		
		// keep going up if possible
		while true {
			let up = program.children.first { $0.isBalanced == false }
			if up == nil {
				break
			}
			program = up!
		}
		
		// Calculate the difference
		let value      = program.totalWeight
		let sibling    = program.parent!.children.first { $0.name != program.name }
		let difference = value - sibling!.totalWeight
		
		// find the bad child
		if difference > 0 { // too heavy => find max
			let bad = program.children.max { a, b in a.totalWeight < b.totalWeight }
			result = bad!.weight - difference
		} else if  difference < 0 { // too light => find min
			let bad = program.children.min { a, b in a.totalWeight < b.totalWeight }
			result = bad!.weight + difference
		} else {
			assert(false, "Impossible!")
		}
		
		return "\(result)"
	}
}
