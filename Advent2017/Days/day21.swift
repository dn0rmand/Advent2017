//
//  day21.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day21: Day {
	
	class Pattern
	{
		var size: Int
		var data: UInt
		
		init(input: String) {
			let rows = input.split(separator: "/")
			size = rows.count
			data = 0
			for row in rows {
				for c in row {
					data <<= 1
					if c == "#" {
						data |= 1
					}
				}
			}
		}
		
		func getKey(rotation: Int, flipped: Bool) -> UInt {
			var key: UInt = 0
			for y in 0..<size {
				for x in 0..<size {
					key <<= 1
					if getPixel(x:x, y:y, rotation: rotation, flipped: flipped) {
						key |= 1
					}
				}
			}
			return (key << 1) | (size == 2 ? 0 : 1)
		}
		
		func get(_ x: Int, _ y: Int) -> Bool
		{
			var bit: UInt = 1
			
			bit <<= (size*y + x)
			return (data & bit) != 0
		}
		
		private func getPixel(x: Int, y: Int, rotation: Int, flipped: Bool) -> Bool
		{
			var X = x
			var Y = y
			
			if flipped {
				X = size-1-X
			}

			switch (rotation)
			{
				case 1:
					(X, Y) = (size - 1 - Y, X)
					break

				case 2:
					(X, Y) = (size - 1 - X, size - 1 - Y)
					break
					
				case 3:
					(X, Y) = (Y, size - 1 - X)
					break
				
				default:
					break
			}

			return get(X, Y)
		}
	}

	class Image {
		var data: [Bool]
		var width: Int
		var pixels: Int
		
		init(width: Int)
		{
			self.width = width
			self.data = [Bool].init(repeating: false, count: width*width)
			self.pixels = 0
		}
		
		init()
		{
			width = 3
			data = [false, true, false, false, false, true, true,  true, true]
			pixels = 5
		}
		
		func get(_ x: Int, _ y: Int) -> Bool {
			let i = y*width + x
			return data[i]
		}
		
		func set(_ x: Int, _ y:  Int, _ value: Bool) {
			let i = y*width + x
			data[i] = value
			if value {
				pixels += 1
			}
		}
		
		func getMatch(rules: [UInt:Pattern], x: Int, y: Int) -> Pattern {
			let size: Int = (width % 2 == 0) ? 2 : 3

			var key: UInt = 0
			
			for oy in 0..<size {
				for ox in 0..<size {
					key <<= 1
					if get(x+ox, y+oy) {
						key |= 1
					}
				}
			}
			
			key = (key << 1) | (size == 2 ? 0 : 1)
			
			return rules[key]!
		}
		
		func process(rules: [UInt:Pattern]) -> Image {
			let size = (width % 2 == 0) ? 2 : 3
			let newImage = Image(width: (width / size) * (size+1))
			
			for y in stride(from: 0, to: width, by: size) {
				for x in stride(from: 0, to: width, by: size) {
					let to = getMatch(rules: rules, x: x, y: y)
					
					let YY = (y/size) * (size+1)
					let XX = (x/size) * (size+1)
					
					for ox in 0...size {
						for oy in 0...size {
							let pixel = to.get(ox, oy)
							newImage.set(XX+ox, YY+oy, pixel)
						}
					}
				}
			}
			
			return newImage
		}
	}
	
	func loadRules() -> [UInt:Pattern]
	{
		var rules = [UInt:Pattern]()
		let states = [
			(0, false), (1, false), (2, false), (3, false),
			(0, true),  (1, true),  (2, true),  (3, true)
		]

		for line in input {
			let fromTo = line.split(separator: "=")
			let from = fromTo[0].trimmingCharacters(in: CharacterSet.whitespaces)
			let to = fromTo[1]
			let two = to.index(to.startIndex, offsetBy: 2)
			
			let fromPattern = Pattern(input: from)
			let toPattern = Pattern(input: String(to[two..<to.endIndex]))

			for state in states {
				let k = fromPattern.getKey(rotation: state.0, flipped: state.1)
				rules[k] = toPattern
			}
		}
		
		return rules
	}
	
	override func getDay() -> Int { return 21 }
		
	override func part1() -> String
	{
		let rules = loadRules()
		var image = Image()

		for _ in 1...5 {
			image = image.process(rules: rules)
		}
		
		return "\(image.pixels)"
	}
	
	override func part2() -> String
	{
		let rules = loadRules()
		var image = Image()

		for _ in 1...18 {
			image = image.process(rules: rules)
		}
		
		return "\(image.pixels)"
	}
}
