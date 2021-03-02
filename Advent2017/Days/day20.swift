//
//  day20.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import Foundation

class Day20: Day {
	struct XYZ {
		var X: Int
		var Y: Int
		var Z: Int
		
		init(_ x: Int, _ y: Int, _ z: Int) {
			X = x
			Y = y
			Z = z
		}
		
		func distance() -> Int {
			return abs(X)+abs(Y)+abs(Z)
		}
		
		static func +(l: XYZ, r: XYZ) -> XYZ
		{
			return XYZ(l.X + r.X, l.Y + r.Y, l.Z + r.Z)
		}

		static func ==(l: XYZ, r: XYZ) -> Bool
		{
			return l.X == r.X && l.Y == r.Y && l.Z == r.Z
		}

		static func *(value: XYZ, time: Int) -> XYZ
		{
			return XYZ(value.X * time, value.Y * time, value.Z * time)
		}
	}
	
	class Particle {
		var id: Int
		var dead: Bool
		var position: XYZ
		var velocity: XYZ
		var acceleration: XYZ
		
		static func <(l: Particle, r: Particle) -> Bool {
			if l.acceleration.distance() < r.acceleration.distance() {
				return true
			}
			
			if l.acceleration.distance() > r.acceleration.distance() {
				return false
			}
			
			if l.velocity.distance() < r.velocity.distance() {
				return true
			}
			
			if l.velocity.distance() > r.velocity.distance() {
				return false
			}
			
			return l.position.distance() < r.position.distance()
		}
		
		static func readXYZ(parser: Parser, name: String) -> XYZ {
			Assert(parser.getToken() == name)
			parser.expect(chars: "=<")
			let x = parser.getNumber()
			parser.expect(chars: ",")
			let y = parser.getNumber()
			parser.expect(chars: ",")
			let z = parser.getNumber()
			parser.expect(chars: ">,")
			
			return XYZ(x, y, z)
		}
		
		init(id: Int, data: String) {
			self.id = id
			self.dead = false
			
			let parser = Parser(input: data)
			
			position = Particle.readXYZ(parser: parser, name: "p")
			velocity = Particle.readXYZ(parser: parser, name: "v")
			acceleration = Particle.readXYZ(parser: parser, name: "a")
		}
		
		func move(t: Int) {
			let tt = (t * (t+1)) / 2;

			position = position + (velocity * t) + (acceleration * tt)
			velocity = velocity + (acceleration * t)
		}
	}
	
	override func getDay() -> Int { return 20 }
	
	func load() -> [Particle] {
		var particles = [Particle]()
		for line in input {
			particles.append(Particle(id: particles.count, data: line))
		}
		
		return particles
	}
	
	override func part1() -> String
	{
		var particles = load()
		particles.sort { $0 < $1 }
		
		let d = particles[0].acceleration.distance()
		let i = particles.firstIndex(where: { $0.acceleration.distance() > d })!
		
		// only keep the ones with the same acceleration
		var slowOnes = particles[0..<i]
		for p in slowOnes {
			p.move(t: 10000)
		}

		slowOnes.sort { $0 < $1 }
		return "\(slowOnes[0].id)"
	}
	
	override func part2() -> String
	{
		var particles = load()
		var steps = 0
		
		while steps < 1000 {
			var positions = [String:Particle]()
			var hasDead = false
			for p in particles {
				p.move(t: 1)
				let k = "\(p.position.X),\(p.position.Y),\(p.position.Z)"
				if let p0 = positions[k] {
					hasDead = true
					p0.dead = true
					p.dead = true
				} else {
					positions[k] = p
				}
			}
			
			if hasDead {
				let parts = particles.filter { !$0.dead }
				particles = parts
				steps = 0
			} else {
				steps += 1
			}
		}
		
		return "\(particles.count)"
	}
}
