//
//  day25.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day25: Day {
	class Tape {
		var data = [Int:Bool]()
		var position = 0
		var checksum = 0
		
		func read() -> Bool {
			if let c = data[position] {
				return c
			} else {
				return false
			}
		}
		
		func write(_ value: Bool) {
			if read() == value { return } // nothing to do
			data[position] = value
			if value { checksum += 1 } else { checksum -= 1}
		}
		
		func goLeft() {
			position -= 1
		}
		
		func goRight() {
			position += 1
		}
		
		func move(_ direction: Int) {
			position += direction
		}
	}
	
	class State {
		var value0: Bool
		var direction0: Int
		var state0: String
		var value1: Bool
		var direction1: Int
		var state1: String
		
		init() {
			value0 = false
			direction0 = 0
			state0 = "A"
			value1 = false
			direction1 = 0
			state1 = "A"
		}
		
		func process(tape: Tape) -> String {
			if tape.read() {
				tape.write(value1)
				tape.move(direction1)
				return state1
			} else {
				tape.write(value0)
				tape.move(direction0)
				return state0
			}
		}
	}
	
	class TuringMachine {
		var tape = Tape()
		var currentState: String = "A"
		var steps = 0
		var states = [String: State]()
		
		func process() {
			for _ in 1...steps {
				if let state = states[currentState] {
					currentState = state.process(tape: tape)
				}
			}
		}
		
		func expect(_ parser: Parser, _ tokens: [String]) {
			for token in tokens {
				Assert(parser.getToken() == token)
			}
		}
		
		func parseCommand(parser: Parser, expectedValue: Int) -> (Bool, Int, String) {
			var writeValue: Bool
			var direction: Int
			var nextState: String
			
			expect(parser, ["if", "the", "current", "value", "is"])
			Assert(parser.getNumber() == expectedValue)
			parser.expectOnce(char: ":")
			
			// - Write the value 0.
			parser.expectOnce(char: "-")
			expect(parser, ["write", "the", "value"])
			writeValue = parser.getNumber() != 0
			parser.expectOnce(char: ".")
			
			// - Move one slot to the left.
			parser.expectOnce(char: "-")
			expect(parser, ["move", "one", "slot", "to", "the"])
			switch parser.getToken() {
				case "right":
					direction = 1
					break
				case "left":
					direction  = -1
					break
				default:
					direction = 0
					Assert(false, "Invalid direction")
					break
			}
			parser.expectOnce(char: ".")
			
			// - Continue with state A.
			parser.expectOnce(char: "-")
			expect(parser, ["continue", "with", "state"])
			nextState = parser.getToken()
			parser.expectOnce(char: ".")
			
			return (writeValue, direction, nextState)
		}
		
		init(input: String) {
			let parser = Parser(input: input.lowercased())
			
			// starting state
			expect(parser, ["begin","in","state"])
			currentState = parser.getToken()
			parser.expectOnce(char: ".")
			
			// number of steps
			expect(parser, ["perform","a","diagnostic", "checksum","after"])
			steps = parser.getNumber()
			expect(parser, ["steps"])
			parser.expectOnce(char: ".")

			// read states
			
			while !parser.EOF() {
				expect(parser, ["in", "state"])
				
				let stateId = parser.getToken()
				let state = State()

				parser.expectOnce(char: ":")
				
				(state.value0, state.direction0, state.state0) = parseCommand(parser: parser, expectedValue: 0)
				(state.value1, state.direction1, state.state1) = parseCommand(parser: parser, expectedValue: 1)
				
				states[stateId] = state
			}
		}
	}
	
	override func getDay() -> Int { return 25 }
	
	override func part1() -> String
	{
		let machine = TuringMachine(input: getDayContent(day: getDay()))
		
		machine.process()
		
		return "\(machine.tape.checksum)"
	}
	
	override func part2() -> String
	{
		return "That's it, you're all done"
	}
}

/*
Begin in state A.
Perform a diagnostic checksum after 12399302 steps.

In state A:

In state B:

In state C:
  If the current value is 0:
	- Write the value 1.
	- Move one slot to the right.
	- Continue with state D.
  If the current value is 1:
	- Write the value 1.
	- Move one slot to the right.
	- Continue with state A.

In state D:
  If the current value is 0:
	- Write the value 1.
	- Move one slot to the left.
	- Continue with state E.
  If the current value is 1:
	- Write the value 0.
	- Move one slot to the left.
	- Continue with state D.

In state E:
  If the current value is 0:
	- Write the value 1.
	- Move one slot to the right.
	- Continue with state F.
  If the current value is 1:
	- Write the value 1.
	- Move one slot to the left.
	- Continue with state B.

In state F:
  If the current value is 0:
	- Write the value 1.
	- Move one slot to the right.
	- Continue with state A.
  If the current value is 1:
	- Write the value 1.
	- Move one slot to the right.
	- Continue with state E.
*/
