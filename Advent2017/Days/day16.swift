//
//  day16.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day16: Day {
	enum PasDeDanceType {
		case Spin
		case Exchange
		case Partner
	}
	struct PasDeDance {
		var type: PasDeDanceType
		var pos: Int
		var index1: Int
		var index2: Int
		var letter1: UInt8
		var letter2: UInt8
		
		init(_ pas: String)
		{
			pos = 0
			index1 = 0
			index2 = 0
			letter1 = 0
			letter2 = 0
			type = .Spin
			
			switch pas[pas.startIndex] {
				case "s":
					type = .Spin
					pos = 16 - Int(pas[pas.index(after: pas.startIndex)..<pas.endIndex])!
					break

				case "p":
					type = .Partner
					letter1 = pas[pas.index(after: pas.startIndex)].asciiValue!
					letter2 = pas[pas.index(before:pas.endIndex)].asciiValue!
					break
				
				case "x":
					let i  = pas.firstIndex(of: "/")!
					type = .Exchange
					index1 = Int(pas[pas.index(after: pas.startIndex)..<i])!
					index2 = Int(pas[pas.index(after: i)..<pas.endIndex])!
					break
					
				default:
					assert(false, "Invalid pas de dance")
			}
		}
	}
	
	override func getDay() -> Int { return 16 }
	
	func loadDance() -> [PasDeDance]
	{
		var dance = [PasDeDance]()
		for pas in items { dance.append(PasDeDance(pas)) }
		return dance
	}
	
	func performDance(_ current: String, dance: [PasDeDance]) -> String {
		var dancers = current.map { $0.asciiValue! }
		var tmpDancers = current.map { $0.asciiValue! }
		
		for pas in dance {
			switch pas.type {
				case .Spin:
					for i in 0..<16 {
						tmpDancers[i] = dancers[(pas.pos+i) % 16]
					}
					(dancers, tmpDancers) = (tmpDancers, dancers)
					break

				case .Partner:
					let i1 = dancers.firstIndex(of: pas.letter1)!
					let i2 = dancers.firstIndex(of: pas.letter2)!
					dancers[i2] = pas.letter1
					dancers[i1] = pas.letter2
					break
				
				case .Exchange:
					dancers.swapAt(pas.index1, pas.index2)
					break
			}
		}
		
		return String(bytes: dancers, encoding: .ascii)!
	}
	
	override func part1() -> String
	{
		return performDance("abcdefghijklmnop", dance: loadDance())
	}
	
	override func part2() -> String
	{
		let max = 1000000000
		let dance = loadDance()
		
		var current = "abcdefghijklmnop"
		var visited = [String:Int]()
		
		visited[current] = 0
		var i = 0
		while i < max {
			i += 1
			current = performDance(current, dance: dance)
			let old = visited[current]
			if old != nil {
				let frequency = i - old!
				let remainder = max % frequency
				for _ in 0..<remainder {
					current = performDance(current, dance: dance)
				}
				break
			} else {
				visited[current] = i
			}
		}
		
		return current
	}
}
