//
//  day23.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day23: Day {
	override func getDay() -> Int { return 23 }
	
	override func part1() -> String
	{
		let duet = Duet.Program(input)
		let context = Duet.Context(0)
		var result = 0
		
		duet.run(context, willExecute: { if $0.opCode == .mul { result += 1 }})
		return "\(result)"
	}
	
	override func part2() -> String
	{
		let duet = Duet.Program(input)
		
		duet.instructions[11] = Duet.Instruction(.set, Duet.RegisterValue("g"), Duet.RegisterValue("b"))
		duet.instructions[12] = Duet.Instruction(.mod, Duet.RegisterValue("g"), Duet.RegisterValue("d"))
		duet.instructions[13] = Duet.Instruction(.jnz, Duet.RegisterValue("g"), Duet.NumberValue(4))
		duet.instructions[14] = Duet.Instruction(.set, Duet.RegisterValue("f"), Duet.NumberValue(0))
		duet.instructions[15] = Duet.Instruction(.set, Duet.RegisterValue("g"), Duet.NumberValue(1))
		duet.instructions[16] = Duet.Instruction(.jnz, Duet.RegisterValue("g"), Duet.NumberValue(8))
		duet.instructions[17] = Duet.Instruction(.nop)
		duet.instructions[18] = Duet.Instruction(.nop)
		duet.instructions[19] = Duet.Instruction(.nop)
		
		let context = Duet.Context(0)

		context.registers(key: "a", value: 1)
		duet.run(context) 
		
		return "\(context.registers(key: "h"))"
	}
}
