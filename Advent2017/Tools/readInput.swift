//
//  readInput.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

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
	
	func getToken() -> String {
		skipWhiteSpaces()
		assert(pos < input.endIndex)
		assert(input[pos].isLetter)
		
		let start = pos
		while(pos < input.endIndex && input[pos].isLetter) {
			pos = input.index(pos, offsetBy: 1)
		}
		let token = String(input[start..<pos])
		return token
	}
	
	func getNumber() -> Int {
		skipWhiteSpaces()
		assert(pos < input.endIndex)
		assert(input[pos].isNumber || input[pos] == "-")
		
		let start = pos
		if input[pos] == "-" { pos = input.index(pos, offsetBy: 1) }
		let start2 = pos
		while(pos < input.endIndex && input[pos].isNumber) {
			pos = input.index(pos, offsetBy: 1)
		}
		assert(start2 < pos) // at least 1 digit
		let s = input[start..<pos]
		let n = Int(s)!
		return n
	}
	
	func getOperator() -> String {
		skipWhiteSpaces()
		assert(pos < input.endIndex)
		assert(input[pos].isPunctuation || input[pos].isSymbol)
		
		let start = pos
		while(pos < input.endIndex && (input[pos].isPunctuation || input[pos].isSymbol)) {
			pos = input.index(pos, offsetBy: 1)
		}
		let op = String(input[start..<pos])
		return op
	}
}
