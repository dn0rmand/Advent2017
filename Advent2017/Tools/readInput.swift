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
				let line2 = line.trimmingCharacters(in: CharacterSet.whitespaces)
				lines.append(line2)
			}
		}
	}
	
	return lines
}
