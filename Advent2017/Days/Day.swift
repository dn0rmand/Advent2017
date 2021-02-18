//
//  Day.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation
import SwiftUI

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
		var timeElapsed = Int((CACurrentMediaTime() - startTime) * 1000000) // in μs
		
		let μs      = timeElapsed % 1000
		timeElapsed = (timeElapsed - μs) / 1000
		let ms 		= timeElapsed % 1000
		timeElapsed = (timeElapsed - ms) / 1000
		let seconds = timeElapsed % 60
		timeElapsed = (timeElapsed - seconds) / 60
		let minutes = timeElapsed % 60
		timeElapsed = (timeElapsed - minutes) / 60
		let hours 	= timeElapsed

		var format = ""
		if hours > 0 { format = "\(hours) hours" }
		if minutes > 0 { format = "\(format) \(minutes) minutes" }
		if seconds > 0 { format = "\(format) \(seconds) seconds" }
		if ms > 0 { format = "\(format) \(ms) ms" }
		if μs > 0 { format = "\(format) \(μs) μs" }
		
		if format.count == 0 { format = "so very fast!" }
		
		output.Print(message: "Executed in \(format)")
	}
}
