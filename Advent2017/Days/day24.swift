//
//  day24.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day24: Day {
	class Component {
		var a: Int
		var b: Int
		var id: Int
		
		init(id: Int, a: Int, b: Int) {
			self.id = id
			self.a = a
			self.b = b
		}
		
		var strength : Int { get { return a + b } }
	}
	
	func loadComponents() -> [Int:[Component]] {
		var components = [Component]()
		
		var id = 0
		for line in input {
			id += 1
			let parser = Parser(input: line)
			let a = parser.getNumber()
			parser.expect(chars: "/")
			let b = parser.getNumber()
			components.append(Component(id: id, a: a, b: b))
			if a != b {
				components.append(Component(id: id, a: b, b: a))
			}
		}
		components.sort {
			if $0.a == $1.a {
				return $0.b < $1.b
			} else {
				return $0.a < $1.a
			}
		}
		
		var map = [Int:[Component]]()
		var previous = -1
		var current  = [Component]()
		
		for component in components {
			if previous != component.a {
				if previous != -1 {
					map[previous] = current
				}
				previous = component.a
				current  = [Component]()
			}
			
			current.append(component)
		}
		
		if previous != -1 {
			map[previous] = current
		}

		return map
	}
	
	override func getDay() -> Int { return 24 }
	
	var executingPart2 = false
	
	func makeBridge(expectedPort: Int , components: [Int:[Component]], used: [Int:Bool]) -> (Int, Int)
	{
		let comps = components[expectedPort]
		if comps == nil {
			return (0, 0)
		}
		
		var maxStrength = 0
		var maxLength = 0
		var inUse = used
		
		for component in comps! {
			if let u = used[component.id] {
				if u {
					continue
				}
			}
			
			inUse[component.id] = true
			var (strength, length) = makeBridge(expectedPort: component.b, components: components, used: inUse)
			strength += component.strength
			length   += 1
			inUse[component.id] = false
			
			if executingPart2 {
				if length > maxLength {
					maxStrength = strength
					maxLength = length
				} else if length == maxLength && maxStrength < strength {
					maxStrength = strength
				}
			} else if maxStrength < strength {
				maxStrength = strength
			}
		}
		
		return (maxStrength, maxLength)
	}
	
	override func part1() -> String
	{
		executingPart2 = false
		
		let components = loadComponents()
		let (max, _) = makeBridge(expectedPort: 0, components: components, used: [Int:Bool]())
		
		return "\(max)"
	}
	
	override func part2() -> String
	{
		executingPart2 = true
		
		let components = loadComponents()
		let (max, _) = makeBridge(expectedPort: 0, components: components, used: [Int:Bool]())
		
		return "\(max)"
	}
}
