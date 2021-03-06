//
//  readInput.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

func formatTime(time: Int) -> String {
	var timeElapsed = time
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
	
	return format
}

func getDayContent(day: Int) -> String {
	let fileName = String.localizedStringWithFormat("day%d", day)
	if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "txt", subdirectory: "data") {
		if let fileContent = try? String(contentsOf: fileUrl) {
			return fileContent
		}
	}
	
	return ""
}

func getDayInput(day: Int) -> [String] {
	var lines = [String]()
	
	let fileName = String.localizedStringWithFormat("day%d", day)
	if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "txt", subdirectory: "data") {
		if let fileContent = try? String(contentsOf: fileUrl) {
			for line in fileContent.split(separator: "\n") {
				let line2 = line.trimmingCharacters(in: .whitespaces)
				lines.append(line2)
			}
		}
	}
	
	return lines
}

func getDayItems(day: Int, separator: Character) -> [String] {
	var items = [String]()
	
	for line in getDayInput(day: day) {
		for item in line.split(separator: separator) {
			items.append(String(item.trimmingCharacters(in: .whitespaces)))
		}
	}
	
	return items
}

class Parser {
	var input: String
	var pos: String.Index
	
	init(input: String) {
		self.input = input
		self.pos   = input.startIndex
	}

	private func skipWhiteSpaces() {
		while pos < input.endIndex && input[pos].isWhitespace {
			pos = input.index(pos, offsetBy: 1)
		}
	}
	
	func EOF() -> Bool {
		skipWhiteSpaces()
		return pos >= input.endIndex
	}
	
	func Peek() -> Character {
		skipWhiteSpaces()
		if EOF() {
			return "\0"
		} else {
			return input[pos]
		}
	}
	func getToken() -> String {
		skipWhiteSpaces()
		Assert(pos < input.endIndex)
		Assert(input[pos].isLetter)
		
		let start = pos
		while(pos < input.endIndex && input[pos].isLetter) {
			pos = input.index(pos, offsetBy: 1)
		}
		let token = String(input[start..<pos])
		return token
	}
	
	func getNumber() -> Int {
		skipWhiteSpaces()
		Assert(pos < input.endIndex)
		Assert(input[pos].isNumber || input[pos] == "-")
		
		let start = pos
		if input[pos] == "-" { pos = input.index(pos, offsetBy: 1) }
		let start2 = pos
		while(pos < input.endIndex && input[pos].isNumber) {
			pos = input.index(pos, offsetBy: 1)
		}
		Assert(start2 < pos) // at least 1 digit
		let s = input[start..<pos]
		let n = Int(s)!
		return n
	}

	func expectOnce(char: Character) {
		skipWhiteSpaces()
		Assert(pos < input.endIndex)
		Assert(input[pos] == char)
		pos = input.index(pos, offsetBy: 1)
	}
	
	func expect(chars: String) {
		skipWhiteSpaces()
		Assert(pos < input.endIndex)
		Assert(chars.contains(input[pos]))
		while pos < input.endIndex && chars.contains(input[pos]) {
			pos = input.index(pos, offsetBy: 1)
		}
	}
	
	func getOperator() -> String {
		skipWhiteSpaces()
		Assert(pos < input.endIndex)
		Assert(input[pos] == "=" || input[pos] == "<" || input[pos] == ">" || input[pos] == "!")
		
		let start = pos
		while(pos < input.endIndex && (
            input[pos] == "=" || 
            input[pos] == "<" ||
            input[pos] == ">" ||
            input[pos] == "!")) {
			pos = input.index(pos, offsetBy: 1)
		}
		let op = String(input[start..<pos])
		return op
	}
}
