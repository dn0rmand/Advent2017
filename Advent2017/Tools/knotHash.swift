//
//  knotHash.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/20/21.
//

import Foundation

class KnotHash {
	let hexCharacters = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
	
	var skip = 0
	var current = 0
	var data = Array(0..<256)
	var sequences: [Int]
	
	init(_ sequences: [Int]) {
		self.sequences = sequences
	}

	init(_ sequence: String) {
		sequences = sequence.map { Int($0.asciiValue!) }
		sequences.append(contentsOf: [17, 31, 73, 47, 23])
	}
	
	func hash(_ turns: Int) -> KnotHash {
		for _  in 1...turns {
			for sequence in sequences {
				let start = current
				let seq   = sequence / 2
				
				for i in 0..<seq {
					let s = (start + i) % 256
					let e = (start + sequence - i - 1 + 256) % 256
					let tmp = data[s]
					data[s] = data[e]
					data[e] = tmp
				}
				
				current = (current + sequence + skip) % 256
				skip = (skip + 1) % 256
			}
		}
		
		return self
	}
	
	func toHEX() -> String {
		var result = ""
		
		for i in  0..<16 {
			let value = self.data[i*16..<(i+1)*16].reduce(0) { $0 ^ $1 }
			result = String.init(format: "%@%02x", result, value)
		}
				
		return result
	}
	
	func toRaw() -> [UInt8] {
		var result = [UInt8]()
		
		for i in  0..<16 {
			let value = self.data[i*16..<(i+1)*16].reduce(0) { $0 ^ $1 }
			result.append(UInt8(value))
		}
				
		return result
	}
}
