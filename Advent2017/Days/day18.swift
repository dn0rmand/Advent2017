//
//  day18.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day18: Day {

	override func getDay() -> Int { return 18 }
	
	override func part1() -> String
	{
		let duet = Duet.Program(input)
		let context = Duet.Context(0)
		
		var result = 0
		
		context.input = {
			if $0.getValue(context) != 0 {
				result = context.output[context.output.count-1]
				
				context.move(offset: duet.instructions.count+1) // force stop
			}
			return true
		}
		
		duet.run(context)
		
		return "\(result)"
	}
		
	override func part2() -> String
	{
		let duet 	 = Duet.Program(input)
		let context1 = Duet.Context(1)
		let context  = Duet.ContextSwitcher(Duet.Context(0), context1)
				
		duet.run(context)
		
		return "\(context1.sent)"
	}
}
