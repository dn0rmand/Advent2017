//
//  Day.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation
import SwiftUI

extension String: LocalizedError {
	public var errorDescription: String? { return self }
}

func Assert(_ condition: Bool, _ message: String) {
	assert(condition, message)
}

func Assert(_ condition: Bool) {
	assert(condition)
}

class Day {
	lazy var input: [String] = {
		return getDayInput(day: self.getDay())
	}()
	
	lazy var items: [String] = {
		var _items = [String]()
		
		for line in input {
			for item in line.split(separator: ",") {
				_items.append(String(item.trimmingCharacters(in: .whitespaces)))
			}
		}
		
		return _items
	}()
	
	func getDay() ->Int { return 0 }
	
	func part1() -> String { return "Part 1 Not Implemented" }
	func part2() -> String { return "Part 2 Not Implemented" }
	
	func reset() { }
	
	func execute(output: ContentView) {
		reset()
		
		let d = getDay()
		
		output.Clear()
		output.Print(message: "--- Day \(d) ---")
		output.Print(message: "")
		
		let startTime = CACurrentMediaTime()
		let p1 = self.part1();
		output.Print(message:"Answer to part1 is \(p1)")
		let p2 = self.part2();
		output.Print(message:"Answer to part2 is \(p2)")
		let timeElapsed = Int((CACurrentMediaTime() - startTime) * 1000000) // in μs
		let format = formatTime(time: timeElapsed)
		output.Print(message: "Executed in \(format)\n")
	}
}
