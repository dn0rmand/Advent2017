//
//  day4.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day4: Day {
	override func getDay() -> Int { return 4 }
	
	override func part1() -> String
	{
		var total = 0
		for phrase in input {
			var used = Set<Substring>()
			var valid = true
			for word in phrase.split(separator: " ") {
				if used.contains(word) {
					valid = false
					break
				}
				used.insert(word)
			}
			if valid { total += 1 }
		}
		return "\(total)"
	}
	
	override func part2() -> String
	{
		var total = 0
		for phrase in input {
			var used = Set<String>()
			var valid = true
			for word in phrase.split(separator: " ") {
				let anagram = String(word.sorted())
				if used.contains(anagram) {
					valid = false
					break
				}
				used.insert(anagram)
			}
			if valid { total += 1 }
		}
		return "\(total)"
	}
}
