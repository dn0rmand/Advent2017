//
//  day12.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day12: Day {
	override func getDay() -> Int { return 12 }
	
	class Program {
		var id: Int;
		var talkTo: [Program]
		var expanded: Bool
		
		init(_ id: Int) {
			self.id = id
			talkTo = [Program]()
			expanded = false
		}
		
		func Add(program: Program) {
			talkTo.append(program)
		}

		func expand() {
			if expanded { return }
			var map = [Int:Program]()
			var added = [Program]()
			
//			map[id] = self
			added.append(self)
			while added.count > 0 {
				var newAdded = [Program]()
				for p in added {
					for a in p.talkTo {
						if map[a.id] == nil {
							map[a.id] = a
							newAdded.append(a)
						}
					}
				}
				added = newAdded
			}
			expanded = true
			talkTo = map.map { $1 }
		}
	}
	
	func loadPrograms() -> [Int:Program]
	{
		var programs = [Int:Program]()
		
		for line in input {
			let parser = Parser(input: line)
			let id = parser.getNumber()
			
			var program = programs[id]
			if program == nil {
				program = Program(id)
				programs[id] = program!
			}
			
			while !parser.EOF()
			{
				_ = parser.getOperator()
				let subId = parser.getNumber()
				var sub = programs[subId]
				if sub == nil {
					sub = Program(subId)
					programs[subId] = sub!
				}
				
				program?.Add(program: sub!)
			}
		}
		
		return programs
	}
	
	override func part1() -> String
	{
		let programs = loadPrograms()
		let p0 = programs[0]!
		
		p0.expand()
		
		let total = p0.talkTo.count
		
		return "\(total)"
	}
	
	override func part2() -> String
	{
		let programs = loadPrograms()
		
		var groups = 0
		var knownOf = [Int:Int]()
		
		for (id, p) in programs {
			if knownOf[id] == nil {
				p.expand()
				groups += 1
				for s in p.talkTo { knownOf[s.id] = s.id }
			}
		}
		
		return "\(groups)"
	}
}
