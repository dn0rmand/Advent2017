//
//  Day.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation
import SwiftUI

class Day {
	private var _input: [String]? = nil
	
	var input: [String] {
		get {
			if self._input == nil {
				self._input = getDayInput(day: self.getDay())
			}
			
			return self._input!
		}
	}
	
	func getDay() ->Int { return 0 }
	
	func part1() -> String { return "Part 1 Not Implemented" }
	func part2() -> String { return "Part 2 Not Implemented" }
	
	func execute(output: ContentView) {
		let d = getDay()
		
		output.Clear()
		output.Print(message: "--- Day \(d) ---")
		output.Print(message: "")
		
		let p1 = self.part1();
		output.Print(message:"Answer to part1 is \(p1)")
		let p2 = self.part2();
		output.Print(message:"Answer to part1 is \(p2)")
	}
}
